import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/register/customer_register_post_req.dart';
import 'package:flutter_application_1/model/request/customer_login_post_req.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text(
              "ชื่อ นามสกุล",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 5, right: 16),
            child: TextField(
              controller: name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "หมายเลขโทรศัพท์",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 5, right: 16),
            child: TextField(
              controller: phoneNo,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "อีเมล",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 5, right: 16),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "รหัสผ่าน",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 5, right: 16),
            child: TextField(
              controller: password,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "ยืนยันรหัสผ่าน",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 5, right: 16),
            child: TextField(
              controller: confirmpassword,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' ', style: TextStyle(fontSize: 20)),
              FilledButton(
                onPressed: () => register(),
                child: const Text('สมัคสมาชิก'),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {},
                  child: const Text('หากมีบัญชีอยู่แล้ว'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: const Text('เข้าสู่ระบบ'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void register() {
    CustomerRegisterPostResponse customerRegisterPostRequest =
        CustomerRegisterPostResponse(
          fullname: name.text,
          phone: phoneNo.text,
          email: email.text,
          image: '', // Placeholder for image URL
          password: password.text,
        );

    http
        .post(
          Uri.parse("http://192.168.82.175:5000/customers"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerRegisterPostResponseToJson(customerRegisterPostRequest),
        )
        .then((value) {
          CustomerRegisterPostResponse response =
              customerRegisterPostResponseFromJson(value.body);
        });
  }
}
