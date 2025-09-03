import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/profile.dart';

class LotteryScreen extends StatelessWidget {
  const LotteryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737),
      body: Stack(
        children: [
          // พื้นหลังสีขาวสำหรับข้อมูลด้านบน
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

          // ข้อความ "งวดวันที่ 1 สิงหาคม 2568"
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

          // ข้อความ "ตรวจผลสลาก"
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

          // ปุ่ม "ตรวจสลากของคุณ"
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
              child: Text(
                "ตรวจสลากของคุณ",
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFFF0FFFF),
                  fontFamily: "Roboto",
                ),
              ),
            ),
          ),

          // พื้นหลังสีขาวด้านล่าง
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
      Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Basket',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  },
      // เพิ่ม BottomNavigationBar ที่นี่
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed, // ทำให้ทุก item แสดงผล
      //   backgroundColor: const Color(0xFFFCC737),
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.white,
      //   items: [
      //     const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     const BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_bag),
      //       label: "Shop",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const Profile()),
      //           );
      //         },
      //         child: const Icon(Icons.person),
      //       ),
      //       label: "Profile",
      //     ),
      //     const BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_basket),
      //       label: "Basket",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //         onTap: () {
      //           // Logic สำหรับการนำทางไปยังหน้า HomePage
      //           Navigator.of(context).popUntil((route) => route.isFirst);
      //         },
      //         child: const Icon(Icons.logout),
      //       ),
      //       label: "Logout",
      //     ),
      //   ],
      // ),
    );
  }
}
