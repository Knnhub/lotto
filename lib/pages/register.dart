import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/config/config.dart'; // อ่าน apiEndpoint จาก assets

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final phoneNoCtl = TextEditingController();
  final amountCtl = TextEditingController(); // optional

  bool _obscureTextPassword = true;
  bool _loading = false;
  String _baseUrl = ""; // apiEndpoint จาก config.json

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((cfg) {
      setState(() {
        _baseUrl = (cfg['apiEndpoint'] ?? '').toString();
      });
    });
  }

  @override
  void dispose() {
    nameCtl.dispose();
    emailCtl.dispose();
    passwordCtl.dispose();
    phoneNoCtl.dispose();
    amountCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737),
      appBar: AppBar(
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
            const SizedBox(height: 50),
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
                minHeight: MediaQuery.of(context).size.height * 0.7,
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
                      "REGISTER",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: nameCtl,
                      labelText: "ชื่อ-นามสกุล (ไม่บังคับ)",
                      icon: Icons.person,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: emailCtl,
                      labelText: "อีเมล (ไม่บังคับ)",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      controller: passwordCtl,
                      labelText: "รหัสผ่าน (ไม่บังคับ)",
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: phoneNoCtl,
                      labelText: "เบอร์โทร (ไม่บังคับ)",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: amountCtl,
                      labelText: "จำนวนเงินเริ่มต้น (ไม่บังคับ)",
                      icon: Icons.account_balance_wallet,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: _loading ? null : _register,
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
                                'ลงทะเบียน',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                      ),
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

  // TextField ปกติ
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

  // Password Field
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
            onPressed: () =>
                setState(() => _obscureTextPassword = !_obscureTextPassword),
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

  Future<void> _register() async {
    if (_baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ยังอ่านค่าเซิร์ฟเวอร์ไม่เสร็จ ลองอีกครั้ง'),
        ),
      );
      return;
    }

    // ประกอบ payload เฉพาะฟิลด์ที่มีค่า (ไม่บังคับกรอก)
    final payload = <String, dynamic>{};

    void addField(String key, String? value) {
      final v = (value ?? '').trim();
      if (v.isNotEmpty) payload[key] = v;
    }

    addField("full_name", nameCtl.text);
    addField("email", emailCtl.text);
    addField("password", passwordCtl.text);
    addField("phone", phoneNoCtl.text);

    // amount: ถ้าพิมพ์ไม่ใช่ตัวเลข เราจะ "ไม่ส่ง" แทนที่จะ error
    final amt = amountCtl.text.trim();
    if (amt.isNotEmpty) {
      final m = int.tryParse(amt);
      if (m != null) payload["money"] = m;
    }

    final base = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final uri = Uri.parse('$base/register');

    setState(() => _loading = true);
    try {
      final res = await http.post(
        uri,
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(payload), // ← ส่งเฉพาะที่มี
      );

      final body = res.body.isEmpty ? {} : jsonDecode(res.body);

      if (res.statusCode == 201) {
        final uid = body is Map && body['uid'] != null ? body['uid'] : null;
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('สมัครสำเร็จ uid=$uid')));
        Navigator.pop(context); // กลับไปหน้า Login
      } else {
        final msg = (body is Map && body['error'] is String)
            ? body['error'] as String
            : 'สมัครไม่สำเร็จ (${res.statusCode})';
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
