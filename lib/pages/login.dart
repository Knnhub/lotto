import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/model/request/customer_login_post_req.dart';
import 'package:flutter_application_1/model/respone/customer_login_post_res.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtrip.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  String url = '';
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737),
      appBar: AppBar(
        // เพิ่ม AppBar ที่นี่
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
            const SizedBox(height: 120),
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
                minHeight: MediaQuery.of(context).size.height * 0.6,
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
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: phoneCtl,
                      labelText: "ชื่อผู้ใช้",
                      icon: Icons.person,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      controller: passwordCtl,
                      labelText: "รหัสผ่าน",
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: login,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFCC737),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("ยังไม่มีบัญชีใช่ไหม?"),
                        TextButton(
                          onPressed: register,
                          child: const Text('ลงทะเบียน'),
                        ),
                      ],
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
        obscureText: _obscureText,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void login() {
    // final req = CustomerLoginPostRequest(
    //   phone: phoneCtl.text,
    //   password: passwordCtl.text,
    // );
    // http
    //     .post(
    //       Uri.parse("$API_ENDPOINT/customers/login"),
    //       headers: {"Content-Type": "application/json; charset=utf-8"},
    //       body: customerLoginPostRequestToJson(req),
    //     )
    //     .then((value) {
    //       log(value.body);
    //       CustomerLoginPostResponse customerLoginPostResponse =
    //           customerLoginPostResponseFromJson(value.body);
    //       log(customerLoginPostResponse.customer.fullname);
    //       log(customerLoginPostResponse.customer.email);
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => const Showtrippage()),
    //       );
    //     })
    //     .catchError((error) {
    //       log('Error $error');
    //     });
  }
}
