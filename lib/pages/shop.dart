import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/respone/user_get_lotter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lottery.dart';

// หน้าหลักสำหรับการค้นหาสลาก
class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _LotteryPageState();
}

class _LotteryPageState extends State<Shop> {
  String u2 = '';
  final TextEditingController _searchController = TextEditingController();

  List<UserGetLotteryRespones> _lotteries = [];
  List<UserGetLotteryRespones> _searchResults = [];
  final Set<int> _purchasedNumbers = {}; // ใช้เก็บเลขที่ซื้อแล้ว

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        u2 = config['apiEndpoint'];
      });
      _fetchLotteries(); // เรียกหลังจากได้ค่า apiEndpoint แล้ว
    });
  }

  Future<void> _fetchLotteries() async {
    final url = Uri.parse('$u2/lottery');

    try {
      final res = await http.get(url);

      print("📡 Response status: ${res.statusCode}");
      print("📡 Response body: ${res.body}");

      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        print("✅ Decoded data length: ${data.length}");
        print("✅ First item: ${data.isNotEmpty ? data[0] : "No data"}");

        final list = data
            .map((e) => UserGetLotteryRespones.fromJson(e))
            .toList();

        setState(() {
          _lotteries = List<UserGetLotteryRespones>.from(list);
          _searchResults = _lotteries;
        });

        print("🎯 _lotteries length: ${_lotteries.length}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("โหลดข้อมูลไม่สำเร็จ (${res.statusCode})")),
        );
      }
    } catch (e) {
      print("❌ Error fetching lotteries: $e");
    }
  }

  void _searchLottery() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _searchResults = _lotteries;
      } else {
        _searchResults = _lotteries
            .where((lot) => lot.number.toString().contains(query))
            .toList();
      }
    });
  }

  void _confirmBuy(int number) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ยืนยันการซื้อ"),
        content: Text("คุณต้องการซื้อลอตเตอรี่เลข $number ใช่หรือไม่?"),
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

    if (ok == true) {
      setState(() {
        _purchasedNumbers.add(number);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("คุณซื้อเลข $number เรียบร้อยแล้ว")),
      );

      // TODO: ถ้าอยากให้ซื้อแล้ว update DB -> เรียก API POST/PUT ไปที่ Go server ที่นี่
    }
  }

  Widget _buildLotteryCard(UserGetLotteryRespones lot) {
    final bool bought = _purchasedNumbers.contains(lot.number);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: const Color(0xFFFCC737),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${lot.price} บาท',
                  style: GoogleFonts.kanit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: bought ? null : () => _confirmBuy(lot.number),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bought ? Colors.white70 : Colors.white,
                    disabledBackgroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    bought ? 'ซื้อแล้ว' : 'ซื้อล็อตเตอรี่',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: lot.number
                  .toString()
                  .split('')
                  .map(
                    (digit) => Container(
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
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCC737),
        automaticallyImplyLeading: false,
        title: Text(
          "ร้านขายลอตเตอรี่",
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "ค้นหาเลขลอตเตอรี่",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (_) => _searchLottery(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchLottery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCC737),
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Icon(Icons.search, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _searchResults.isEmpty
                ? Center(
                    child: Text(
                      'ไม่พบสลากที่ตรงกับคำค้นหา',
                      style: GoogleFonts.kanit(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final lot = _searchResults[index];
                      return _buildLotteryCard(lot);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
