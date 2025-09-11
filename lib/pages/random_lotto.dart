import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/pages/reward.dart';

class AdminRanNum extends StatefulWidget {
  const AdminRanNum({super.key});

  @override
  State<AdminRanNum> createState() => _AdminRanNumState();
}

class _AdminRanNumState extends State<AdminRanNum> {
  final int _currentIndex = 0;

  // เก็บข้อมูลเป็น Map (id, number)
  List<Map<String, String>> lotteryNumbers = [];

  void _onBottomTap(int index) async {
    if (index == _currentIndex) return;
    switch (index) {
      case 1: // Draw Prizes
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AdminDrawPrize()));
        break;
      case 2: // Reset System
        await _confirmReset();
        break;
      case 3: // Logout
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
    }
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ยืนยันการรีเซ็ทระบบ"),
        content: const Text(
          "คุณแน่ใจหรือไม่? การรีเซ็ทจะล้างข้อมูลที่เกี่ยวข้องกับงวด/การซื้อ",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("ยืนยัน"),
          ),
        ],
      ),
    );

    if (ok == true && mounted) {
      setState(() {
        lotteryNumbers.clear();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("รีเซ็ทระบบเรียบร้อย")));
    }
  }

  /// ฟังก์ชันสุ่มเลข 6 หลัก 100 ชุด
  void _generateLotteryNumbers() {
    final rand = Random();
    final List<Map<String, String>> generated = [];
    final Map<String, int> countMap = {}; //เก็บจำนวนครั้งของแต่ละเลข

    while (generated.length < 100) {
      String num = (rand.nextInt(900000) + 100000).toString(); // เลข 6 หลัก
      int count = countMap[num] ?? 0;

      if (count < 5) {
        countMap[num] = count + 1;
        generated.add({"id": (generated.length + 1).toString(), "number": num});
      }
    }

    setState(() {
      lotteryNumbers = generated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFFFCC737),
        automaticallyImplyLeading: false,
        title: Text(
          "สุ่มล็อตเตอรี่",
          style: GoogleFonts.kanit(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _generateLotteryNumbers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCC737),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "สุ่มทั้งหมด",
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // แสดงการ์ด
            Column(
              children: lotteryNumbers.map((item) {
                return _lotteryCard(item["id"]!, item["number"]!);
              }).toList(),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFCC737),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onBottomTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: "สุ่มเลข",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.stars), label: "สุ่มรางวัล"),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: "รีเซ็ตระบบ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "ออกจากระบบ",
          ),
        ],
      ),
    );
  }

  Widget _lotteryCard(String id, String number) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: const Color(0xFFFCC737),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ID: $id",
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "ล็อตเตอรี่",
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: number.split('').map((digit) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    digit,
                    style: GoogleFonts.kanit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
