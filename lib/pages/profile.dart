import 'package:flutter/material.dart';

// เปลี่ยน LotteryScreen ให้เป็น StatefulWidget เพื่อจัดการสถานะการเลือกหน้า
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<Profile> {
  // สถานะปัจจุบันของ bottom navigation bar
  int _selectedIndex = 0;

  // รายการหน้าจอที่สามารถสลับไปมาได้
  static const List<Widget> _pages = <Widget>[
    _LotteryBody(), // หน้าหลัก Lottery
    ProfileScreen(), // หน้า Profile
    Center(child: Text('Shop Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Basket Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Logout Page', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // สามารถเพิ่ม logic สำหรับปุ่มอื่นๆ ได้ที่นี่
    // ตัวอย่างเช่น สำหรับปุ่ม Logout
    if (index == 4) {
      // Logic สำหรับการออกจากระบบ
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737),
      body: _pages[_selectedIndex], // แสดงหน้าจอตามสถานะปัจจุบัน
      // เพิ่ม BottomNavigationBar ที่นี่
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // ทำให้ทุก item แสดงผล
        backgroundColor: const Color(0xFFFCC737),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: "Basket",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Widget สำหรับส่วนแสดงผล Lottery (ถูกแยกออกมาเพื่อให้สามารถใช้ใน _pages ได้)
class _LotteryBody extends StatelessWidget {
  const _LotteryBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}

// --- หน้า Profile (โค้ดที่ปรับปรุงแล้ว) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Section 1: Profile Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 32),
            color: Colors.amber,
            child: Column(
              children: <Widget>[
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://i.pinimg.com/736x/87/d8/00/87d800a935c24e2d35a39537a77e23f0.jpg',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Mr. BOB EIEI',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Section 2: Menu List (ปรับปรุงส่วนนี้)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // New Contact Section
                const Text(
                  'Contact Info',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.email,
                        text: 'bobbob@gmail.com',
                        onTap: () {},
                      ),
                      // Add a new item for phone number
                      ProfileMenuItem(
                        icon: Icons.phone,
                        text: '+66 81-234-5678',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Existing Account Section
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.credit_card,
                        text: 'Wallet: 1000 u.',
                        onTap: () {},
                      ),
                      ProfileMenuItem(
                        icon: Icons.history,
                        text: 'My Lottery',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Widget for Menu Items (ไม่มีการเปลี่ยนแปลง)
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber[800]),
      title: Text(text),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
