// To parse this JSON data, do
//
//     final tripidxGetResponse = tripidxGetResponseFromJson(jsonString);

import 'dart:convert';
import 'trip_get_res.dart';

TripidxGetResponse tripidxGetResponseFromJson(String str) =>
    TripidxGetResponse.fromJson(json.decode(str));

String tripidxGetResponseToJson(TripidxGetResponse data) =>
    json.encode(data.toJson());

class TripidxGetResponse {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripidxGetResponse({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripidxGetResponse.fromJson(Map<String, dynamic> json) =>
      TripidxGetResponse(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "name": name,
    "country": country,
    "coverimage": coverimage,
    "detail": detail,
    "price": price,
    "duration": duration,
    "destination_zone": destinationZone,
  };
}
