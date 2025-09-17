import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/respone/lottery_get_res.dart';
import 'package:flutter_application_1/pages/admin_draw_price.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

/// ---------------------------
/// MAIN WIDGET (หน้าผู้ดูแลสุ่มเลข/สุ่มรางวัล)
/// ---------------------------
class AdminRanNum extends StatefulWidget {
  final int uid;
  AdminRanNum({super.key, required this.uid});

  @override
  State<AdminRanNum> createState() => _AdminRanNumState();
}

class _AdminRanNumState extends State<AdminRanNum> {
  int _currentIndex = 0;
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'] ?? '';
      });
    });
  }

  /// ยืนยันการรีเซ็ตระบบ
  Future<void> _confirmReset() async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ยังโหลด API ไม่เสร็จ")));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ยืนยันการรีเซ็ทระบบ"),
        content: const Text("คุณแน่ใจหรือไม่? การรีเซ็ทจะล้างข้อมูลทั้งหมด"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("ยืนยัน"),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await DeleteSystem();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("รีเซ็ตระบบเรียบร้อย")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminRanNumContent(uid: widget.uid), // tab 0
      AdminDrawPrizeContent(), // tab 1
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFCC737),
        title: Text(
          _currentIndex == 0 ? "สุ่มล็อตเตอรี่" : "สุ่มรางวัล",
          style: GoogleFonts.kanit(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFCC737),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) async {
          if (index == 2) {
            await _confirmReset();
          } else if (index == 3) {
            if (mounted) {
              log("ออกจากระบบ");
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          } else {
            setState(() => _currentIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: "สุ่มเลข",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.stars), label: "สุ่มรางวัล"),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: "รีเซ็ตระบบ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "ออกจากระบบ",
          ),
        ],
      ),
    );
  }

  /// เรียก API รีเซ็ตระบบ
  Future<void> DeleteSystem() async {
    if (url.isEmpty) return;

    try {
      final uri = Uri.parse('$url/Delete'); // url + /Delete
      final res = await http.post(uri); // ใช้ POST ตาม Go route
      if (res.statusCode == 200 || res.statusCode == 201) {
        log("รีเซ็ตระบบเรียบร้อย");
      } else {
        log('รีเซ็ตระบบไม่สำเร็จ: ${res.statusCode}');
      }
    } catch (e) {
      log("เกิดข้อผิดพลาดตอนรีเซ็ตระบบ: $e");
    }
  }
}

/// ---------------------------
/// TAB 0 : เนื้อหาสุ่มเลขล็อตเตอรี่
/// ---------------------------

class AdminRanNumContent extends StatefulWidget {
  int uid = 0;
  AdminRanNumContent({super.key, required this.uid});

  @override
  State<AdminRanNumContent> createState() => _AdminRanNumContentState();
}

class _AdminRanNumContentState extends State<AdminRanNumContent> {
  String url = '';
  List<LotteryGetResponse> lotteryGetResponse = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      getloto();
      // log(widget.uid.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // ปุ่มสุ่มทั้งหมด
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                insertloto();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF35D0BA),

                padding: const EdgeInsets.symmetric(
                  horizontal: 150,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "สุ่มทั้งหมด",
                style: GoogleFonts.kanit(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const CircularProgressIndicator()
          else if (lotteryGetResponse.isEmpty)
            const Text("ยังไม่มีข้อมูลเลขสุ่ม")
          // มีข้อมูล → โชว์เลย
          else
            Column(
              children: lotteryGetResponse
                  .map(
                    (lotto) => _lotteryCard(
                      lotto.number.toString(),
                      lotto.status.toString(),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Future<void> insertloto() async {
    final res = await http.post(
      Uri.parse('$url/lottery/generate/${widget.uid}'),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      await getloto();
    } else {
      log('Failed to generate lottery: ${res.statusCode}');
    }
  }

  getloto() async {
    setState(() => isLoading = true); // เริ่มโหลด
    try {
      final res = await http.get(Uri.parse('$url/lottery'));

      if (res.statusCode == 200) {
        final data = lotteryGetResponseFromJson(res.body);
        setState(() {
          lotteryGetResponse = data;
          isLoading = false; // โหลดเสร็จแล้ว
        });
        log("โหลดข้อมูลสำเร็จ: ${data.length} รายการ");
        // log(res.body);
      } else {
        log("โหลดข้อมูลไม่สำเร็จ: ${res.statusCode}");

        setState(() => isLoading = false);
      }
    } catch (e) {
      log("เกิดข้อผิดพลาด: $e");
      setState(() => isLoading = false);
    }
  }
}

Widget _lotteryCard(String number, String status) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: const Color(0xFFFCC737),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ล็อตเตอรี่",
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: number.split('').map((digit) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  digit,
                  style: GoogleFonts.kanit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
