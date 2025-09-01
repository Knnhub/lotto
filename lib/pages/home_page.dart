import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/register.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LOTTO",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'PressStart2P',
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white, // ตั้งค่าสีพื้นหลังเป็นสีขาว
                  foregroundColor: Colors.black, // ตั้งค่าสีตัวอักษรเป็นสีดำ
                ),
                child: const Text('เข้าสู่ระบบ'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white, // ตั้งค่าสีพื้นหลังเป็นสีขาว
                  foregroundColor: Colors.black, // ตั้งค่าสีตัวอักษรเป็นสีดำ
                ),
                child: const Text('ลงทะเบียน'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
