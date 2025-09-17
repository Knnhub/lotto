// To parse this JSON data, do
//
//     final lotteryGetResponse = lotteryGetResponseFromJson(jsonString);

import 'dart:convert';

List<LotteryGetResponse> lotteryGetResponseFromJson(String str) =>
    List<LotteryGetResponse>.from(
      json.decode(str).map((x) => LotteryGetResponse.fromJson(x)),
    );

String lotteryGetResponseToJson(List<LotteryGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LotteryGetResponse {
  int lid;
  int number;
  int price;
  String status;
  String date;
  int userId;

  LotteryGetResponse({
    required this.lid,
    required this.number,
    required this.price,
    required this.status,
    required this.date,
    required this.userId,
  });

  factory LotteryGetResponse.fromJson(Map<String, dynamic> json) =>
      LotteryGetResponse(
        lid: json["lid"],
        number: json["number"],
        price: json["price"],
        status: json["status"],
        date: json["date"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
    "lid": lid,
    "number": number,
    "price": price,
    "status": status,
    "date": date,
    "user_id": userId,
  };
}
