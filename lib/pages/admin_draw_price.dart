import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/respone/reward_get_res.dart';

class AdminDrawPrizeContent extends StatefulWidget {
  const AdminDrawPrizeContent({super.key});

  @override
  State<AdminDrawPrizeContent> createState() => _AdminDrawPrizeContentState();
}

class PrizeItem {
  final String type;
  final String number;

  PrizeItem({required this.type, required this.number});
}

class _AdminDrawPrizeContentState extends State<AdminDrawPrizeContent> {
  List<PrizeItem> _winningNumbers = [];
  String url = '';
  bool isLoading = true;
  List<RewardGetResponse> rewardGetResponse = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadConfigAndData();
    });
  }

  void _loadConfigAndData() async {
    final config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    getReward();
  }

  getReward() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse('$url/reward/get'));
      log(url);
      if (res.statusCode == 200) {
        final data = rewardGetResponseFromJson(res.body);

        String? twoDigit; // เลขท้าย 2 ตัว
        String? threeDigit; // เลขท้าย 3 ตัว
        List<PrizeItem> numbers = [];

        for (var e in data) {
          if (e.type == 'เลขท้าย 2 ตัว' && twoDigit == null) {
            twoDigit = e.number.substring(e.number.length - 2);
          } else if (e.type == 'เลขท้าย 3 ตัว' && threeDigit == null) {
            threeDigit = e.number.substring(e.number.length - 3);
          } else if (e.type != 'เลขท้าย 2 ตัว' && e.type != 'เลขท้าย 3 ตัว') {
            numbers.add(PrizeItem(type: e.type, number: e.number));
          }
        }

        // เพิ่มเลขท้าย 2 ตัว / 3 ตัว แค่ตัวเดียว
        if (twoDigit != null)
          numbers.add(PrizeItem(type: 'เลขท้าย 2 ตัว', number: twoDigit));
        if (threeDigit != null)
          numbers.add(PrizeItem(type: 'เลขท้าย 3 ตัว', number: threeDigit));

        setState(() {
          rewardGetResponse = data;
          _winningNumbers = numbers;
          isLoading = false;
        });

        log("โหลดข้อมูลสำเร็จ: ${data.length} รายการ");
      } else {
        log("โหลดข้อมูลไม่สำเร็จ: ${res.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      log("เกิดข้อผิดพลาด: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        // ปุ่มสุ่มทั้งหมด (จะเลื่อนพร้อมการ์ด)
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              insertloto();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF35D0BA),
              padding: const EdgeInsets.symmetric(
                horizontal: 150,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "สุ่มรางวัล",
              style: GoogleFonts.kanit(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // แสดงการ์ดรางวัล
        ..._winningNumbers.map((p) => _lotteryCard(p)).toList(),
      ],
    );
  }

  Widget _lotteryCard(PrizeItem prize) {
    final number = prize.number;
    final type = prize.type;

    // ตรวจว่าเป็นเลขท้าย 2 ตัวหรือ 3 ตัว
    final isLastTwoOrThree =
        type.contains("เลขท้าย 2 ตัว") || type.contains("เลขท้าย 3 ตัว");

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFFCC737),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  type, // แสดงชนิดรางวัล
                  style: GoogleFonts.kanit(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // แสดงตัวเลข
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: number.split('').map((digit) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLastTwoOrThree
                        ? 2
                        : 8, // เลขท้าย 2/3 ตัวชิด, รางวัลใหญ่ห่าง
                  ),
                  child: Container(
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
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> insertloto() async {
    final res = await http.post(Uri.parse('$url/reward/insert'));
    if (res.statusCode == 200 || res.statusCode == 201) {
      getReward();
    } else {
      log('Failed to generate lottery: ${res.statusCode}');
    }
  }
}
