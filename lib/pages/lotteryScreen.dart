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
    final pages = <Widget>[
      const LotteryScreenContent(), // index 0
      Shop(uid: widget.uid), // index 1
      Profile(uid: widget.uid), // index 2 (ยังส่ง uid ตามเดิม)
      const Busget(), // index 3
    ];

    return Scaffold(
      extendBody: true, // ให้เนื้อหาลื่นใต้แถบล่าง เงาดูเนียน
      body: pages[_currentIndex],

      // ===== แถบล่างแบบไม่มีช่องว่างสีขาว & มีอินดิเคเตอร์ชัดเจน =====
      bottomNavigationBar: Material(
        color: const Color(0xFFFCC737), // เติมสีทับ safe area ล่างให้หมด
        elevation: 8,
        child: SafeArea(
          top: false,
          bottom: true,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: const Color(0xFFFCC737),
              indicatorColor: Colors.white, // เม็ดไฮไลต์
              surfaceTintColor: Colors.transparent, // กัน overlay เทา
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
              onDestinationSelected: (index) {
                if (index == 4) {
                  // Logout → กลับไปหน้าต้นทาง (ตามเดิม)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  return;
                }
                setState(() => _currentIndex = index);
              },
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

/// เหลือเฉพาะส่วนบน + คอนเทนเนอร์สีขาวด้านล่าง (ไม่มีการ์ดรายการ)
class LotteryScreenContent extends StatefulWidget {
  const LotteryScreenContent({super.key});

  @override
  State<LotteryScreenContent> createState() => _LotteryScreenContentState();
}

class _LotteryScreenContentState extends State<LotteryScreenContent> {
  Future<void> _onCheckPressed() async {
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

              // คอนเทนเนอร์สีขาวด้านล่าง
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
                        _prizeBox(
                          title: "รางวัลที่ 2",
                          number: "9 9 9 9 9 9",
                          prize: "2,000,000 บาท",
                        ),
                        _prizeBox(
                          title: "รางวัลที่ 3",
                          number: "8 8 8 8 8 8",
                          prize: "1,000,000 บาท",
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _prizeBox(
                          title: "เลขท้าย 3 ตัว",
                          number: "9 9 9",
                          prize: "4,000 บาท",
                        ),
                        _prizeBox(
                          title: "เลขท้าย 2 ตัว",
                          number: "9 9",
                          prize: "4,000 บาท",
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

  Widget _prizeBox({
    required String title,
    required String number,
    required String prize,
  }) {
    return Column(
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title,
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
            border: Border.all(color: const Color(0xFFFCC737), width: 4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(prize, style: GoogleFonts.kanit(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
