import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/register/customer_register_post_req.dart';
import 'package:flutter_application_1/model/request/customer_login_post_req.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:flutter_application_1/pages/login.dart'; // Import LoginPage for navigation

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameCtl =
      TextEditingController(); // เปลี่ยนชื่อเพื่อให้สอดคล้องกับ UI
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController amountCtl = TextEditingController(); // สำหรับจำนวนเงิน
  bool _obscureTextPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737), // สีพื้นหลัง
      appBar: AppBar(
        // เพิ่ม AppBar
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50), // เพิ่มระยะห่างด้านบน
            Text(
              "LOTTO",
              style: GoogleFonts.jersey10(
                textStyle: const TextStyle(
                  fontSize: 128,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height *
                    0.7, // กำหนดความสูงขั้นต่ำ
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "REGISTER", // เปลี่ยนเป็น Register
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: nameCtl,
                      labelText: "ชื่อผู้ใช้",
                      icon: Icons.person,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: emailCtl,
                      labelText: "อีเมล",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      controller: passwordCtl,
                      labelText: "รหัสผ่าน",
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: phoneNoCtl,
                      labelText: "เบอร์โทร",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: amountCtl,
                      labelText: "จำนวนเงิน", // เพิ่มช่องจำนวนเงิน
                      icon: Icons.account_balance_wallet,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: register,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFCC737),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'ลงทะเบียน',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget สำหรับ TextField ทั่วไป
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  // Widget สำหรับ PasswordField
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: _obscureTextPassword,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureTextPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                _obscureTextPassword = !_obscureTextPassword;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  void register() {
    // ต้องแก้ไข logic การลงทะเบียนให้ถูกต้องตาม API ของคุณ
    // ตัวอย่างการสร้าง CustomerRegisterPostRequest
    // โดยสมมติว่าคุณมี model/register/customer_register_post_req.dart และฟังก์ชัน customerRegisterPostResponseToJson
    /*
    final req = CustomerRegisterPostRequest(
      fullname: nameCtl.text,
      phone: phoneNoCtl.text,
      email: emailCtl.text,
      password: passwordCtl.text,
      // เพิ่ม fields อื่นๆ ตาม model ของคุณ
      // เช่น initialBalance: double.parse(amountCtl.text),
    );

    http
        .post(
          Uri.parse("http://192.168.82.175:5000/customers"), // เปลี่ยน URL API ของคุณ
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerRegisterPostRequestToJson(req),
        )
        .then((value) {
          // จัดการ response
          // เช่น ถ้าสำเร็จให้กลับไปหน้า Login
          Navigator.pop(context); // กลับไปหน้าก่อนหน้า (Login)
        })
        .catchError((error) {
          // จัดการ error
          print('Error during registration: $error');
        });
    */

    // สำหรับตอนนี้แค่กลับไปหน้า Login เพื่อให้ UI ทำงานได้
    Navigator.pop(context);
  }
}
