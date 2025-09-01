import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home_page.dart'; // import ไฟล์ใหม่

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotto App', // เปลี่ยนชื่อ title ให้เหมาะสม
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ), // เปลี่ยนสีหลักให้เข้ากับ Lotto
        useMaterial3: true,
      ),
      home: const HomePage(), // เปลี่ยนหน้า home เป็น HomePage
    );
  }
}
