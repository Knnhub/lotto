import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/respone/trip_idx_get_res.dart';
import 'package:http/http.dart' as http;

class TripPage extends StatefulWidget {
  final int idx;
  const TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  // สร้าง Future ที่จะเก็บผลลัพธ์จาก API
  late Future<TripidxGetResponse> loadData;

  @override
  void initState() {
    super.initState();
    // เรียกฟังก์ชันโหลดข้อมูลและเก็บ Future ไว้ในตัวแปร loadData
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดทริป'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      // ใช้ FutureBuilder เพื่อรอข้อมูลจาก Future
      body: FutureBuilder<TripidxGetResponse>(
        future: loadData,
        builder: (context, snapshot) {
          // หากสถานะยังรออยู่ ให้แสดง Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // หากมีข้อผิดพลาด ให้แสดงข้อความแจ้งเตือน
          if (snapshot.hasError) {
            log('Error: ${snapshot.error}');
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }
          // หากข้อมูลมาถึงแล้ว ให้แสดงข้อมูล
          if (snapshot.hasData) {
            final trip = snapshot.data!;
            // ตอนนี้คุณสามารถ log ข้อมูลได้แล้ว
            log('Trip Name: ${trip.name}');

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ส่วนแสดงรูปภาพหลักของทริป
                  Image.network(
                    trip.coverimage,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // ส่วนแสดงรายละเอียดของทริป
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'ประเทศ: ${trip.country}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'รายละเอียด:',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(trip.detail, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ระยะเวลา: ${trip.duration} วัน',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '฿${trip.price}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          // กรณีที่ไม่มีข้อมูล
          return const Center(child: Text('ไม่พบข้อมูลทริป'));
        },
      ),
    );
  }

  Future<TripidxGetResponse> loadDataAsync() async {
    var config = await Configuration.getConfig();
    String url = config['apiEndpoint'];
    final res = await http.get(Uri.parse('$url/trips/${widget.idx}'));

    // คำสั่ง log() จะทำงานที่นี่และจะแสดงผลใน Debug Console
    log('API Response Body: ${res.body}');

    // แปลงข้อมูล JSON เป็น object และส่งคืนค่า Future
    return tripidxGetResponseFromJson(res.body);
  }
}
