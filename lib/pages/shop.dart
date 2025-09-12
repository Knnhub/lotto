import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/respone/user_get_lotter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lottery.dart';
import 'package:flutter/services.dart';

// หน้าหลักสำหรับการค้นหาสลาก
class Shop extends StatefulWidget {
  final int uid;
  const Shop({super.key, required this.uid});

  @override
  State<Shop> createState() => _LotteryPageState();
}

class _LotteryPageState extends State<Shop> {
  String u2 = '';
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _purchasedNumbers = {};

  List<UserGetLotteryRespones> _lotteries = [];
  List<UserGetLotteryRespones> _searchResults = [];

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        u2 = config['apiEndpoint'];
      });
      _fetchLotteries();
    });
  }

  Future<void> _fetchLotteries() async {
    final url = Uri.parse('$u2/lottery');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        final list = data
            .map((e) => UserGetLotteryRespones.fromJson(e))
            .toList();
        setState(() {
          _lotteries = List<UserGetLotteryRespones>.from(list);
          _searchResults = _lotteries;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("โหลดข้อมูลไม่สำเร็จ (${res.statusCode})")),
        );
      }
    } catch (e) {
      debugPrint("❌ Error fetching lotteries: $e");
    }
  }

  void _searchLottery() {
    final raw = _searchController.text.trim();
    setState(() {
      if (raw.isEmpty) {
        _searchResults = _lotteries;
      } else {
        _searchResults = _lotteries
            .where((lot) => lot.number.toString().contains(raw))
            .toList();
      }
    });
  }

  void _confirmBuy(UserGetLotteryRespones lot) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "ยืนยันการซื้อ",
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "คุณต้องการซื้อลอตเตอรี่เลข ${lot.number} ราคา ${lot.price} บาท ใช่หรือไม่?",
          style: GoogleFonts.kanit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("ยกเลิก", style: GoogleFonts.kanit()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFCC737),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "ยืนยัน",
              style: GoogleFonts.kanit(color: Colors.black),
            ),
          ),
        ],
      ),
    );

    if (ok != true) {
      debugPrint("🚫 User cancelled buy dialog");
      return;
    }

    try {
      final int userId = widget.uid;
      final uri = Uri.parse('$u2/user?uid=$userId');

      final balanceRes = await http.get(uri);
      debugPrint("📡 GET $uri => ${balanceRes.statusCode}");

      if (balanceRes.statusCode == 404) {
        debugPrint("❌ User not found: uid=$userId");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌ ไม่พบผู้ใช้")));
        return;
      }

      if (balanceRes.statusCode != 200) {
        debugPrint("❌ Failed to load balance: ${balanceRes.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("โหลดยอดเงินไม่สำเร็จ")));
        return;
      }

      final data = json.decode(balanceRes.body);
      final balance = data['wallet'] as int;
      debugPrint("💰 Current balance: $balance");

      if (balance < lot.price) {
        debugPrint("❌ Balance not enough: need ${lot.price}, have $balance");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌ เงินไม่พอในการซื้อ")));
        return;
      }

      final payload = {"userId": userId, "lotteryId": lot.lid};
      debugPrint("📡 Request buy: $u2/buy with $payload");

      final buyRes = await http.post(
        Uri.parse('$u2/buy'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      if (buyRes.statusCode == 200) {
        setState(() {
          _purchasedNumbers.add(lot.number);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("🎉 คุณซื้อเลข ${lot.number} เรียบร้อยแล้วจ้า"),
          ),
        );
        _fetchLotteries();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ซื้อไม่สำเร็จ (${buyRes.statusCode})")),
        );
      }
    } catch (e) {
      debugPrint("❌ Exception while buying: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("เกิดข้อผิดพลาดในการซื้อ")));
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
                  onPressed: bought || lot.lid == null
                      ? null
                      : () => _confirmBuy(lot),
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
      backgroundColor: const Color(0xFFFCC737),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Center(
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "ซื้อล็อตเตอรี่",
                        style: GoogleFonts.kanit(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "ค้นหาเลขลอตเตอรี่",
                          hintStyle: GoogleFonts.kanit(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.search),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        onChanged: (_) => _searchLottery(),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _searchLottery,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFCC737),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          "ค้นหาล็อตเตอรี่",
                          style: GoogleFonts.kanit(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16,
                  ),
                  child: _searchResults.isEmpty
                      ? Center(
                          child: Text(
                            'ไม่พบสลากที่ตรงกับคำค้นหา',
                            style: GoogleFonts.kanit(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final lot = _searchResults[index];
                            return _buildLotteryCard(lot);
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
