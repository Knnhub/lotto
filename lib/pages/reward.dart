import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/pages/admin_ran_num.dart';
import 'package:flutter_application_1/pages/random_lotto.dart';

class AdminDrawPrize extends StatefulWidget {
  const AdminDrawPrize({super.key});

  @override
  State<AdminDrawPrize> createState() => _AdminDrawPrizeState();
}

class _AdminDrawPrizeState extends State<AdminDrawPrize> {
  // แท็บปัจจุบัน = Draw Prizes
  final int _currentIndex = 1;
  final List<String> lotteryNumbers = const ['123456', '654321', '112233'];
  void _onBottomTap(int index) async {
    if (index == _currentIndex) return; // ถ้าแตะแท็บเดิม ไม่ต้องทำอะไร
    switch (index) {
      case 0: // Generate Tickets
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AdminRanNum()));
        break;
      case 2: // Reset System (แสดง dialog ในหน้านี้)
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
          "คุณแน่ใจหรือไม่? การรีเซ็ทจะล้างข้อมูลที่เกี่ยวข้องกับงวด/การซื้อ (ตัวอย่าง)",
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
      // TODO: ใส่ลอจิกรีเซ็ตจริง เช่น เรียก API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("รีเซ็ทระบบเรียบร้อย (ตัวอย่าง)")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFFFCC737),
        automaticallyImplyLeading: false,
        title: Text(
          "สุ่มรางวัล",
          style: GoogleFonts.kanit(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: Center(
        child: Column(children: lotteryNumbers.map(_lotteryCard).toList()),
      ),

      // BottomNavigationBar (แสดงครบ 4 ไอคอน)
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

  Widget _lotteryCard(String number) {
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
                  "ล็อตเตอรี่",
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "ขายแล้ว",
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
