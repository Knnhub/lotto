import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:flutter_application_1/model/respone/trip_get_res.dart';
import 'package:flutter_application_1/pages/trip.dart';
import 'package:http/http.dart' as http;

class Showtrippage extends StatefulWidget {
  const Showtrippage({super.key});

  @override
  State<Showtrippage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Showtrippage> {
  List<TripsGetResponse> _allTrips = [];
  List<TripsGetResponse> _filteredTrips = [];
  late Future<void> loadData;
  @override
  void initState() {
    super.initState();
    loadData = getTrips();
  }

  // onlu one Ececution
  // Cannot run asyn function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('รายการทริป')),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text('ปลายทาง'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 8,
                      children: [
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _filteredTrips = _allTrips;
                            });
                          },
                          child: Text('ทั้งหมด'),
                        ),
                        FilledButton(
                          onPressed: () {
                            _filterTrips(DestinationZone.SOUTHEAST_ASIA);
                          },
                          child: Text('เอเชียตะวันออกเฉียงใต้'),
                        ),
                        FilledButton(
                          onPressed: () {
                            _filterTrips(DestinationZone.EUROPE);
                          },
                          child: Text('ยุโรป'),
                        ),
                        FilledButton(
                          onPressed: () {
                            _filterTrips(DestinationZone.THAILAND);
                          },
                          child: Text('ประเทศไทย'),
                        ),
                        FilledButton(
                          onPressed: () {
                            _filterTrips(DestinationZone.ASIA);
                          },
                          child: Text('เอเชีย'),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = _filteredTrips[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // รูปภาพ
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  trip.coverimage,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 180,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.broken_image),
                                        ),
                                      ),
                                ),
                              ),

                              // เนื้อหาทัวร์
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      trip.country,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      trip.detail.length > 100
                                          ? '${trip.detail.substring(0, 100)}...'
                                          : trip.detail,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${trip.duration} วัน',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '฿${trip.price}',
                                          style: const TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            gotoTrip(trip.idx);
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         TripPage(idx: trip.idx),
                                            //   ),
                                            // );
                                          },
                                          child: const Text(
                                            'รายละเอียดเพิ่มเติม',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Add the Expanded widget here inside the Column
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> getTrips() async {
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));
    List<TripsGetResponse> trips = tripsGetResponseFromJson(res.body);
    setState(() {
      _allTrips = trips;
      _filteredTrips = _allTrips;
    });
    log(_allTrips.length.toString());
  }

  void _filterTrips(DestinationZone zone) {
    setState(() {
      _filteredTrips = _allTrips
          .where((trip) => trip.destinationZone == zone)
          .toList();
    });
  }

  void gotoTrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }
}
