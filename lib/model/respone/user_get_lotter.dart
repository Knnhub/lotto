// To parse this JSON data, do
//
//     final userGetLotteryRespones = userGetLotteryResponesFromJson(jsonString);

import 'dart:convert';

List<UserGetLotteryRespones> userGetLotteryResponesFromJson(String str) =>
    List<UserGetLotteryRespones>.from(
      json.decode(str).map((x) => UserGetLotteryRespones.fromJson(x)),
    );

String userGetLotteryResponesToJson(List<UserGetLotteryRespones> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserGetLotteryRespones {
  int number;
  int price;
  String status;
  String date;
  int? lid;
  int userId;

  UserGetLotteryRespones({
    required this.number,
    required this.price,
    required this.status,
    required this.date,
    this.lid,
    required this.userId,
  });

  factory UserGetLotteryRespones.fromJson(Map<String, dynamic> json) =>
      UserGetLotteryRespones(
        number: json["number"] ?? 0,
        price: json["price"] ?? 0,
        status: json["status"] ?? '',
        date: json["date"] ?? '',
        lid: json["lid"], // null ได้
        userId: json["user_id"] ?? 0, // null ได้
      );

  Map<String, dynamic> toJson() => {
    "number": number,
    "price": price,
    "status": status,
    "date": date,
    "lid": lid,
    "user_id": userId,
  };
}
