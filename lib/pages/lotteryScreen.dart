import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/busget.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/shop.dart';
import 'package:google_fonts/google_fonts.dart';

class LotteryScreen extends StatefulWidget {
  final int uid;
  const LotteryScreen({super.key, required this.uid});

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const LotteryScreenContent(), // index 0
      const Shop(), // index 1
      Profile(uid: widget.uid), // index 2
      const Busget(), // index 3
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFCC737),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex:
            _currentIndex, //currentIndex เป็นตัวบอกว่าตอนนี้เลือกเมนูไหน
        onTap: (index) {
          if (index == 4) {
            // Logout
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Shop",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "My Lottery",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
      ),
    );
  }
}

/// เหลือเฉพาะส่วนบน + คอนเทนเนอร์สีขาวด้านล่าง (ไม่มีการ์ดรายการแล้ว)
class LotteryScreenContent extends StatefulWidget {
  const LotteryScreenContent({super.key});

  @override
  State<LotteryScreenContent> createState() => _LotteryScreenContentState();
}

class _LotteryScreenContentState extends State<LotteryScreenContent> {
  Future<void> _onCheckPressed() async {
    // ✅ ป๊อปอัพแสดงผลว่าถูกรางวัล
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber),
            const SizedBox(width: 8),
            Text(
              'ยินดีด้วย!',
              style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text('คุณถูกรางวัล!', style: GoogleFonts.kanit(fontSize: 16)),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFCC737),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('ปิด', style: GoogleFonts.kanit(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ส่วนบน (หัวเรื่อง + งวด + กล่องเลขตัวอย่าง + ปุ่ม)
              Center(
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "ตรวจผลสลาก",
                          style: GoogleFonts.kanit(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "งวดวันที่ 1 สิงหาคม 2568",
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (_) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCC737),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "1",
                              style: GoogleFonts.kanit(fontSize: 20),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _onCheckPressed,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFCC737),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          "ตรวจสลากของคุณ",
                          style: GoogleFonts.kanit(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // คอนเทนเนอร์สีขาวด้านล่าง (เว้นพื้นที่ไว้ ไม่มีการ์ดรายการแล้ว)
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "รางวัลที่ 1",
                        style: GoogleFonts.kanit(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (_) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCC737),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "1",
                            style: GoogleFonts.kanit(fontSize: 30),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "6,000,000 บาท",
                      style: GoogleFonts.kanit(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // รางวัลที่ 2
                        Column(
                          children: [
                            Container(
                              width: 180,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFCC737),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "รางวัลที่ 2",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kanit(fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              width: 180,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFFCC737),
                                  width: 4,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "9 9 9 9 9 9",
                                    style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "2,000,000 บาท",
                                    style: GoogleFonts.kanit(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // รางวัลที่ 3
                        Column(
                          children: [
                            Container(
                              width: 180,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFCC737),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "รางวัลที่ 3",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kanit(fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              width: 180,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFFCC737),
                                  width: 4,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "8 8 8 8 8 8",
                                    style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "1,000,000 บาท",
                                    style: GoogleFonts.kanit(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // เลขท้าย 3 ตัว
                        Column(
                          children: [
                            Container(
                              width: 180,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFCC737),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "เลขท้าย 3 ตัว",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kanit(fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              width: 180,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFFCC737),
                                  width: 4,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "9 9 9",
                                    style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "4,000 บาท",
                                    style: GoogleFonts.kanit(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // เลขท้าย 2 ตัว
                        Column(
                          children: [
                            Container(
                              width: 180,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFCC737),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "เลขท้าย 2 ตัว",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kanit(fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              width: 180,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFFCC737),
                                  width: 4,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "9 9",
                                    style: GoogleFonts.kanit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "4,000 บาท",
                                    style: GoogleFonts.kanit(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
