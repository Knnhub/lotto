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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // แก้ไข constructor ให้เป็น const

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = ' ';
  int number = 0;
  String phoneNo = '';
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  String url = '';

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
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')), // เพิ่ม AppBar
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset('assets/images/Orb3.png'), // ส่วนนี้สามารถลบออกได้หากไม่ต้องการ
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 30),
                child: Text(
                  "เบอร์โทรศัพท์", // เปลี่ยนข้อความให้ชัดเจน
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: phoneCtl,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, top: 30),
                child: Text(
                  "รหัสผ่าน", // เปลี่ยนข้อความให้ชัดเจน
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: passwordCtl,
                  obscureText: true, // เพิ่มเพื่อซ่อนรหัสผ่าน
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
              ),

              Center(
                // จัดปุ่มให้อยู่ตรงกลาง
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => login(),
                      child: const Text('เข้าสู่ระบบ'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: register,
                      child: const Text('ลงทะเบียนใหม่'),
                    ),
                  ],
                ),
              ),
            ],
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

  void login(/*String phone, String password*/) {
    // ... โค้ดเดิม
    final req = CustomerLoginPostRequest(
      phone: phoneCtl.text,
      password: passwordCtl.text,
    );
    http
        .post(
          Uri.parse("$API_ENDPOINT/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          log(value.body);
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Showtrippage()),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
