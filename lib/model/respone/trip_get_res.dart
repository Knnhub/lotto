// To parse this JSON data, do
//
//     final tripsGetResponse = tripsGetResponseFromJson(jsonString);

import 'dart:convert';

List<TripsGetResponse> tripsGetResponseFromJson(String str) =>
    List<TripsGetResponse>.from(
      json.decode(str).map((x) => TripsGetResponse.fromJson(x)),
    );

String tripsGetResponseToJson(List<TripsGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripsGetResponse {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  DestinationZone destinationZone;

  var imageUrl;

  TripsGetResponse({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripsGetResponse.fromJson(Map<String, dynamic> json) =>
      TripsGetResponse(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: destinationZoneValues.map[json["destination_zone"]]!,
      );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "name": name,
    "country": country,
    "coverimage": coverimage,
    "detail": detail,
    "price": price,
    "duration": duration,
    "destination_zone": destinationZoneValues.reverse[destinationZone],
  };
}

enum DestinationZone { SOUTHEAST_ASIA, EUROPE, THAILAND, ASIA }

final destinationZoneValues = EnumValues({
  "เอเชียตะวันออกเฉียงใต้": DestinationZone.SOUTHEAST_ASIA,
  "ยุโรป": DestinationZone.EUROPE,
  "ประเทศไทย": DestinationZone.THAILAND,
  "เอเชีย": DestinationZone.ASIA,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
