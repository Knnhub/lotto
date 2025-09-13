import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  final int uid; // ใช้เรียก API เท่านั้น - ไม่แสดงใน UI
  const Profile({Key? key, required this.uid}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool _topupLoading = false;

  // เปลี่ยนให้ตรง environment ของคุณ
  final String baseUrl = "http://10.0.2.2:8080/api";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // ===== Helpers =====
  int _readMoney(Map<String, dynamic> u) {
    final raw = u['money'] ?? u['wallet'] ?? u['balance'] ?? 0;
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw) ?? 0;
    return 0;
  }

  String _initialsFromName(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1)
      return parts.first.characters.take(2).toString().toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  Color _roleColor(String role) {
    switch ((role).toUpperCase()) {
      case 'ADMIN':
        return Colors.deepPurple;
      case 'MEMBER':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===== API =====
  Future<void> fetchUserData() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/user?uid=${widget.uid}'));
      if (res.statusCode == 200) {
        setState(() {
          userData = json.decode(res.body) as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        _toast('โหลดข้อมูลไม่สำเร็จ (${res.statusCode})');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _toast('เชื่อมต่อเซิร์ฟเวอร์ไม่ได้');
    }
  }

  void _showTopUpDialog() {
    final amountCtl = TextEditingController();
    final quicks = [100, 500, 1000];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> _confirm() async {
            final amount = int.tryParse(amountCtl.text) ?? 0;
            if (amount <= 0) {
              _toast('กรุณากรอกจำนวนเงินให้ถูกต้อง');
              return;
            }
            setDialogState(() => _topupLoading = true);

            int? newMoneyFromResponse;
            try {
              final res = await http.post(
                Uri.parse('$baseUrl/wallet/topup'),
                headers: {'Content-Type': 'application/json'},
                body: json.encode({
                  'uid': widget.uid, // กันเหนียวแนบสองชื่อคีย์
                  'userId': widget.uid,
                  'amount': amount,
                  'amount_str': amount.toString(),
                }),
              );

              dynamic body;
              try {
                body = res.body.isEmpty ? {} : json.decode(res.body);
              } catch (_) {
                body = {};
              }

              if (res.statusCode == 200 && body is Map) {
                final raw = body['money'] ?? body['wallet'] ?? body['balance'];
                if (raw is int) newMoneyFromResponse = raw;
                if (raw is String) newMoneyFromResponse = int.tryParse(raw);
              } else if (res.statusCode != 200) {
                _toast('เติมเงินไม่สำเร็จ (${res.statusCode})');
              }
            } catch (e) {
              _toast('เชื่อมต่อเซิร์ฟเวอร์ไม่ได้');
            }

            Navigator.pop(context);

            // ถ้า response มียอดใหม่ก็ตั้งไว้ก่อน
            if (newMoneyFromResponse != null && userData != null) {
              setState(() {
                userData = Map<String, dynamic>.from(userData!);
                userData!['money'] = newMoneyFromResponse;
                userData!['wallet'] = newMoneyFromResponse;
              });
            }

            // ยืนยันกับ DB
            final before = userData == null ? null : _readMoney(userData!);
            await fetchUserData();
            final after = userData == null ? null : _readMoney(userData!);

            if (before != null && after != null) {
              final expectedMin = before + amount;
              if (after < expectedMin) {
                _toast('ฝั่งเซิร์ฟเวอร์ยังไม่อัปเดต ตรวจสอบ API /wallet/topup');
              } else {
                _toast('เติมเงินสำเร็จ +$amount บาท');
              }
            } else {
              _toast('ดำเนินการเติมเงินเสร็จสิ้น');
            }

            setDialogState(() => _topupLoading = false);
          }

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFC64B), Color(0xFFFFC64B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'เติมเงิน Wallet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: amountCtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'จำนวนเงิน (บาท)',
                      hintText: 'เช่น 100',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _topupLoading
                            ? null
                            : () => amountCtl.clear(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final q in quicks)
                        ChoiceChip(
                          label: Text('+$q'),
                          selected: false,
                          onSelected: _topupLoading
                              ? null
                              : (_) {
                                  final cur = int.tryParse(amountCtl.text) ?? 0;
                                  amountCtl.text = (cur + q).toString();
                                },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _topupLoading
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('ยกเลิก'),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _topupLoading ? null : _confirm,
                        icon: _topupLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check_rounded),
                        label: const Text('ยืนยัน'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC64B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===== UI helpers =====
  Widget _walletCard(int money) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'ยอดเงินคงเหลือ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '$money บ.',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _showTopUpDialog,
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('เติมเงิน'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC64B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactCard(String email, String phone) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: _iconBox(Icons.email_rounded),
            title: const Text(
              'อีเมล',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              email.isEmpty ? '-' : email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            dense: true,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: _iconBox(Icons.phone_rounded),
            title: const Text(
              'เบอร์โทร',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              phone.isEmpty ? '-' : phone,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            dense: true,
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.black87),
    );
  }

  // ===== BUILD =====
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text('ไม่สามารถโหลดข้อมูลได้')),
      );
    }

    final fullName = (userData!['full_name'] ?? '').toString();
    final email = (userData!['email'] ?? '').toString();
    final phone = (userData!['phone'] ?? '').toString();
    final role = (userData!['role'] ?? '').toString();
    final money = _readMoney(userData!);

    final avatarUrl = (userData!['avatar']?.toString().isNotEmpty ?? false)
        ? userData!['avatar'].toString()
        : '';
    final initials = _initialsFromName(fullName.isEmpty ? 'User' : fullName);

    // ========= Layout แบบสมดุล: Stack + Gradient Header (ไม่มี Transform) =========
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text('โปรไฟล์'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Header gradient สูงพอดี ไม่ทับคอนเทนต์
          Container(
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC64B), Color(0xFFFFC64B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // เนื้อหาเลื่อนทั้งหมด
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  // การ์ดโปรไฟล์—วางหลัง header 140 โดยเว้นช่องด้านบนให้พอดี
                  SizedBox(height: 70),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.black87,
                          backgroundImage: avatarUrl.isEmpty
                              ? null
                              : NetworkImage(avatarUrl),
                          child: avatarUrl.isEmpty
                              ? Text(
                                  initials,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName.isEmpty ? 'User' : fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _roleColor(role).withOpacity(.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  (role.isEmpty ? 'UNKNOWN' : role)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: _roleColor(role),
                                    letterSpacing: .5,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),
                  _walletCard(money),

                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ข้อมูลติดต่อ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _contactCard(email, phone),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
