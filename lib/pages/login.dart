import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart'; // อ่าน apiEndpoint จาก assets/config/config.json
import 'package:flutter_application_1/pages/admin_ran_num.dart';
import 'package:flutter_application_1/pages/lotteryScreen.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/shop.dart'; // LotteryPage อยู่ในไฟล์นี้ตามโปรเจ็กต์เดิม
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneCtl = TextEditingController();
  final passwordCtl = TextEditingController();

  String _baseUrl = ''; // จาก config.json -> apiEndpoint
  bool _obscureText = true; // ซ่อน/โชว์รหัสผ่าน
  bool _loading = false; // สถานะปุ่มตอนกำลังเรียก API

  @override
  void initState() {
    super.initState();
    // โหลดค่า API endpoint จาก assets
    Configuration.getConfig().then((cfg) {
      setState(() {
        _baseUrl = (cfg['apiEndpoint'] ?? '').toString();
      });
    });
  }

  @override
  void dispose() {
    phoneCtl.dispose();
    passwordCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
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
                      labelText: "เบอร์โทร / ชื่อผู้ใช้",
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
                        onPressed: _loading
                            ? null
                            : _login, // disable ระหว่างโหลด
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFCC737),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("ยังไม่มีบัญชีใช่ไหม?"),
                        TextButton(
                          onPressed: _register,
                          child: const Text('ลงทะเบียน'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_baseUrl.isEmpty)
                      const Text(
                        "กำลังโหลดการตั้งค่าเซิร์ฟเวอร์...",
                        style: TextStyle(color: Colors.grey),
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
            onPressed: () => setState(() => _obscureText = !_obscureText),
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

  void _register() {
    // TODO: ไปหน้า RegisterPage เมื่อพร้อม
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text('เดี๋ยวค่อยต่อ Register นะ')));
  }

  Future<void> _login() async {
    final phone = phoneCtl.text.trim();
    final password = passwordCtl.text;

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรอกเบอร์/ชื่อผู้ใช้ และรหัสผ่านให้ครบ')),
      );
      return;
    }
    if (_baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ยังอ่านค่าเซิร์ฟเวอร์ไม่เสร็จ ลองอีกครั้ง'),
        ),
      );
      return;
    }

    final base = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final uri = Uri.parse('$base/login');

    setState(() => _loading = true);
    try {
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      final body = res.body.isEmpty ? {} : jsonDecode(res.body);

      if (res.statusCode == 200) {
        // ดึง role จาก response
        final user = body['user'] ?? {};
        final role = user['role'] ?? 'user';

        if (!mounted) return;

        if (role == 'ADMIN') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdminRanNum(uid: user['uid'])),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LotteryScreen(uid: user['uid'])),
          );
        }
      } else {
        final msg = (body is Map && body['error'] is String)
            ? body['error'] as String
            : 'เข้าสู่ระบบไม่สำเร็จ (${res.statusCode})';
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ผิดพลาด: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
