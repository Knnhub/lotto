import 'package:flutter/material.dart';

class Busget extends StatelessWidget {
  const Busget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),

      // ✅ ตรงนี้คือเนื้อหาหลัก
      body: Center(
        child: const Text("สินค้าในตะกร้า", style: TextStyle(fontSize: 18)),
      ),

      // ✅ ใช้ BottomNavigationBar จริง ๆ ของ Scaffold
    );
  }
}
