import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  final int uid; // รับ uid ของผู้ใช้
  const Profile({Key? key, required this.uid}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  // ====================== ตั้งค่า Base URL ======================
  // 👉 เปลี่ยนตรงนี้ตาม environment
  final String baseUrl = "http://10.0.2.2:8080/api";
  // Android Emulator = 10.0.2.2
  // iOS Simulator = localhost
  // มือถือจริง = IP LAN ของเครื่องรัน Go เช่น http://192.168.1.50:8080/api

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // ====================== ดึงข้อมูลผู้ใช้ ======================
  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user?uid=${widget.uid}'),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load user: ${response.body}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching user: $e');
      setState(() => isLoading = false);
    }
  }

  // ====================== Top-up wallet ======================
  void _showTopUpDialog() {
    TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                // backgroundColor: Colors.amber,
                child: Icon(Icons.account_balance_wallet, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Top Up Wallet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  labelText: 'Amount (Baht)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      int amount = int.tryParse(amountController.text) ?? 0;
                      if (amount > 0) {
                        final response = await http.post(
                          Uri.parse('$baseUrl/wallet/topup'),
                          headers: {'Content-Type': 'application/json'},
                          body: json.encode({
                            'uid': widget.uid,
                            'amount': amount,
                          }),
                        );
                        print('Top-up response: ${response.body}');
                        if (response.statusCode == 200) {
                          await fetchUserData(); // รีเฟรชข้อมูล wallet
                        }
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text('ไม่สามารถโหลดข้อมูลได้')),
      );
    }

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 32),
            color: Colors.amber,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    (userData!['avatar'] != null && userData!['avatar'] != "")
                        ? userData!['avatar']
                        : 'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userData!['full_name'] ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        Icons.email,
                        userData!['email'] ?? '',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.phone,
                        userData!['phone'] ?? '',
                        () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        Icons.credit_card,
                        'Wallet: ${userData!['wallet'] ?? 0} บ.',
                        _showTopUpDialog,
                      ),
                      _buildMenuItem(Icons.history, 'My Lottery', () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
