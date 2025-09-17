import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/respone/reward_get_res.dart';
import 'package:flutter_application_1/pages/busget.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/shop.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LotteryScreen extends StatefulWidget {
  final int uid;
  const LotteryScreen({super.key, required this.uid});

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
  int _currentIndex = 0;
  String _apiEndpoint = '';
  Future<List<RewardGetResponse>>? _rewardsFuture;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await Configuration.getConfig();
    setState(() {
      _apiEndpoint = config['apiEndpoint'] ?? '';
      _rewardsFuture = _fetchRewards();
    });
  }

  Future<List<RewardGetResponse>> _fetchRewards() async {
    final base = _apiEndpoint.endsWith('/')
        ? _apiEndpoint.substring(0, _apiEndpoint.length - 1)
        : _apiEndpoint;
    final url = '$base/reward/get?_ts=${DateTime.now().millisecondsSinceEpoch}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return rewardGetResponseFromJson(response.body);
    } else {
      throw Exception("Failed to load rewards (${response.statusCode})");
    }
  }

  Future<void> _reloadRewards() async {
    setState(() => _rewardsFuture = _fetchRewards());
    await _rewardsFuture;
  }

  void _onNavTapped(int index) {
    if (index == 4) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      (_rewardsFuture == null)
          ? const Center(child: CircularProgressIndicator())
          : LotteryScreenContent(
              rewardsFuture: _rewardsFuture!,
              onRefresh: _reloadRewards,
            ),
      Shop(uid: widget.uid),
      Profile(uid: widget.uid),
      MyLotteriesPage(userId: widget.uid),
    ];

    return Scaffold(
      extendBody: true,
      body: pages[_currentIndex],
      bottomNavigationBar: Material(
        color: const Color(0xFFFCC737),
        elevation: 8,
        child: SafeArea(
          top: false,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: const Color(0xFFFCC737),
              indicatorColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                (states) => IconThemeData(
                  size: states.contains(WidgetState.selected) ? 26 : 24,
                  color: Colors.black.withOpacity(
                    states.contains(WidgetState.selected) ? 1 : 0.7,
                  ),
                ),
              ),
              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (states) => TextStyle(
                  fontWeight: states.contains(WidgetState.selected)
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            child: NavigationBar(
              height: 64,
              selectedIndex: _currentIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: _onNavTapped,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  selectedIcon: Icon(Icons.shopping_bag),
                  label: 'Shop',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'My Lottery',
                ),
                NavigationDestination(
                  icon: Icon(Icons.logout_outlined),
                  selectedIcon: Icon(Icons.logout),
                  label: 'Logout',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------- LotteryScreenContent ----------------------
class LotteryScreenContent extends StatefulWidget {
  final Future<List<RewardGetResponse>> rewardsFuture;
  final Future<void> Function() onRefresh;

  const LotteryScreenContent({
    super.key,
    required this.rewardsFuture,
    required this.onRefresh,
  });

  @override
  State<LotteryScreenContent> createState() => _LotteryScreenContentState();
}

class _LotteryScreenContentState extends State<LotteryScreenContent> {
  final _controller = TextEditingController();
  String? _checkResult;

  void _checkTicket(List<RewardGetResponse> rewards) {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() => _checkResult = 'กรุณากรอกเลขสลาก');
      return;
    }

    // แปลง input เป็นเลข 6 หลัก (ถ้าน้อยกว่า 6 เติม 0 ข้างหน้า)
    final input6 = input.padLeft(6, '0');
    String? result;

    for (var r in rewards) {
      final rNumber = r.number.toString().padLeft(6, '0');

      // ถ้าเป็นรางวัลเลขท้าย 2 ตัว ตรวจเฉพาะ 2 หลักสุดท้าย
      if (r.type?.contains('เลขท้าย') ?? false) {
        final length = int.parse(r.type!.replaceAll(RegExp(r'[^0-9]'), ''));
        if (input6.substring(6 - length) == rNumber.substring(6 - length)) {
          result = 'ถูกรางวัล ${r.type} (${rNumber}) จำนวน ${r.money} บาท';
          break;
        }
      } else {
        // ตรวจตรง ๆ สำหรับรางวัลปกติ
        if (input6 == rNumber) {
          result =
              'ถูกรางวัล ${r.type ?? 'หลัก'} (${rNumber}) จำนวน ${r.money} บาท';
          break;
        }
      }
    }

    setState(() => _checkResult = result ?? 'ไม่ถูกรางวัล');
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom + 96;

    return SafeArea(
      child: FutureBuilder<List<RewardGetResponse>>(
        future: widget.rewardsFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'โหลดข้อมูลไม่สำเร็จ\n${snap.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kanit(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: widget.onRefresh,
                      child: const Text('ลองใหม่'),
                    ),
                  ],
                ),
              ),
            );
          }

          // final rewards = snap.data ?? const <RewardGetResponse>[];
          final rewards = snap.data ?? const <RewardGetResponse>[];

          // ---------------------- กรองรางวัลเลขท้ายซ้ำ ----------------------
          final displayedRewards = <RewardGetResponse>[];
          final seenLastDigits = <String>{};

          for (var r in rewards) {
            if (r.type?.contains('เลขท้าย') ?? false) {
              final match = RegExp(r'\d+').firstMatch(r.type!);
              if (match != null) {
                final len = int.parse(match.group(0)!);
                final number = r.number
                    .toString()
                    .padLeft(6, '0')
                    .substring(6 - len);
                if (!seenLastDigits.contains('${len}_$number')) {
                  seenLastDigits.add('${len}_$number');
                  displayedRewards.add(r);
                }
              }
            } else {
              displayedRewards.add(r); // รางวัลปกติ
            }
          }

          return RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // -------------------- กล่องตรวจสลาก --------------------
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'ตรวจสลากของคุณ',
                          style: GoogleFonts.kanit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'กรอกเลขสลาก 6 หลัก',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFCC737),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => _checkTicket(rewards),
                          child: Text(
                            'ตรวจผล',
                            style: GoogleFonts.kanit(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (_checkResult != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _checkResult!,
                            style: GoogleFonts.kanit(fontSize: 16),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // -------------------- แสดงรางวัล Grid --------------------
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayedRewards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                    itemBuilder: (ctx, i) {
                      final r = displayedRewards[i];
                      String number = r.number.toString().padLeft(6, '0');

                      // ถ้าเป็นรางวัลเลขท้าย 2 หรือ 3 ตัว ให้แสดงเฉพาะเลขท้าย
                      if (r.type?.contains('เลขท้าย') ?? false) {
                        final match = RegExp(r'\d+').firstMatch(r.type!);
                        if (match != null) {
                          final len = int.parse(match.group(0)!);
                          number = number.substring(6 - len); // เอาเฉพาะเลขท้าย
                        }
                      }

                      return _MiniPrizeCard(
                        title: r.type ?? 'รางวัล ${i + 1}',
                        number: number,
                        prize: '${r.money} บาท',
                        type: r.type ?? 'ทั่วไป',
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------- MiniPrizeCard ----------------------
class _MiniPrizeCard extends StatelessWidget {
  final String title;
  final String number;
  final String prize;
  final String type; // เพิ่ม type

  const _MiniPrizeCard({
    required this.title,
    required this.number,
    required this.prize,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              type, // แสดงประเภทของรางวัล
              style: GoogleFonts.kanit(fontSize: 14, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Center(
              child: FittedBox(
                child: Text(
                  number,
                  style: GoogleFonts.kanit(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(prize, style: GoogleFonts.kanit(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
