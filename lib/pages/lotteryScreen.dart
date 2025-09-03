import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/busget.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/shop.dart';

class LotteryScreen extends StatefulWidget {
  const LotteryScreen({super.key});

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const LotteryScreenContent(), // index 0
    const Shop(), // index 1
    const Profile(), // index 2
    const Busget(), // index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFCC737),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 4) {
            // ✅ Logout → กลับหน้าแรก
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
            icon: Icon(Icons.shopping_cart),
            label: "Basket",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
      ),
    );
  }
}

/// ✅ เนื้อหาหน้า Lottery แยกออกมา
class LotteryScreenContent extends StatelessWidget {
  const LotteryScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737),
      body: Stack(
        children: [
          Positioned(
            left: 38,
            top: 42,
            child: Container(
              width: 323,
              height: 242,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            left: 113,
            top: 126,
            child: Text(
              "งวดวันที่ 1 สิงหาคม 2568",
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFFFCC737),
                fontFamily: "Roboto",
              ),
            ),
          ),
          Positioned(
            left: 110,
            top: 77,
            child: Text(
              "ตรวจผลสลาก",
              style: TextStyle(
                fontSize: 32,
                color: Colors.black,
                letterSpacing: 0.02,
                fontFamily: "Roboto",
              ),
            ),
          ),
          Positioned(
            left: 78,
            top: 223,
            child: Container(
              width: 250,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFFCC737),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: const Text(
                "ตรวจสลากของคุณ",
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFFF0FFFF),
                  fontFamily: "Roboto",
                ),
              ),
            ),
          ),
          Positioned(
            top: 341,
            child: Container(
              width: 411,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
