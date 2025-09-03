import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// หน้าหลักสำหรับการค้นหาสลาก
class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _LotteryPageState();
}

class _LotteryPageState extends State<Shop> {
  // สร้าง Controller สำหรับช่องค้นหา
  final TextEditingController _searchController = TextEditingController();

  // ข้อมูลสลากจำลอง (ตัวอย่าง)
  final List<String> _mockLotteryNumbers = [
    '012345',
    '111222',
    '333444',
    '555666',
    '777888',
    '999000',
    '123456',
    '654321',
    '888888',
    '111111',
    '222222',
    '333333',
  ];

  // รายการสลากที่แสดงผลหลังการค้นหา
  List<String> _searchResults = [];

  // ตะกร้าสินค้า (ใช้ Set เพื่อไม่ให้มีเลขซ้ำ)
  Set<String> _shoppingCart = {};

  @override
  void initState() {
    super.initState();
    // แสดงสลากทั้งหมดเมื่อเปิดหน้าครั้งแรก
    _searchResults = _mockLotteryNumbers;
  }

  // ฟังก์ชันค้นหาสลาก
  void _searchLottery() {
    final String query = _searchController.text;
    setState(() {
      if (query.isEmpty) {
        // ถ้าช่องค้นหาว่าง ให้แสดงสลากทั้งหมด
        _searchResults = _mockLotteryNumbers;
      } else {
        // กรองสลากที่ตรงกับเลขที่พิมพ์
        _searchResults = _mockLotteryNumbers
            .where((number) => number.contains(query))
            .toList();
      }
    });
  }

  // ฟังก์ชันเพิ่มสลากลงในตะกร้า
  void _addToCart(String number) {
    setState(() {
      _shoppingCart.add(number);
    });
    // สามารถเพิ่ม Toast หรือ Snackbar เพื่อแสดงผลว่าเพิ่มสลากแล้ว
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เพิ่มสลากเบอร์ $number ลงในตะกร้าแล้ว!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCC737),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ส่วนหัวสำหรับการค้นหา
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: const Color(0xFFFDEBBD),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'ซื้อล็อตเตอรี่',
                        style: GoogleFonts.kanit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'งวดวันที่ 1 กันยายน 2568',
                        style: GoogleFonts.kanit(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      // กล่องสำหรับใส่ตัวเลข
                      _buildNumberInputRow(),
                      const SizedBox(height: 16),
                      // ปุ่มค้นหา
                      ElevatedButton(
                        onPressed: _searchLottery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFCC737),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'ค้นหาสลากของคุณ',
                          style: GoogleFonts.kanit(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ส่วนแสดงผลการค้นหา
              ..._searchResults
                  .map((number) => _buildLotteryCard(number))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สำหรับสร้างช่องใส่ตัวเลข 6 หลัก
  Widget _buildNumberInputRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          6,
          (index) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _buildDigitInput(index),
            ),
          ),
        ),
      ),
    );
  }

  // Widget สำหรับช่องใส่ตัวเลขแต่ละหลัก
  Widget _buildDigitInput(int index) {
    return TextField(
      controller: TextEditingController(
        text: _searchController.text.length > index
            ? _searchController.text[index]
            : '',
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
      ),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      style: GoogleFonts.kanit(fontSize: 20),
      onChanged: (value) {
        String currentText = _searchController.text;
        if (value.isNotEmpty) {
          if (currentText.length > index) {
            currentText = currentText.replaceRange(index, index + 1, value);
          } else {
            currentText += value;
          }
        } else {
          currentText = currentText.replaceRange(index, index + 1, '');
        }
        _searchController.text = currentText;
      },
    );
  }

  // Widget สำหรับแสดงสลากแต่ละใบ
  Widget _buildLotteryCard(String number) {
    final bool isInCart = _shoppingCart.contains(number);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: const Color(0xFFFDEBBD),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '80 บาท',
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: isInCart ? null : () => _addToCart(number),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCC737),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    isInCart ? 'อยู่ในตะกร้าแล้ว' : 'เลือกใส่ตะกร้า',
                    style: GoogleFonts.kanit(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
