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
  int userId;

  UserGetLotteryRespones({
    required this.number,
    required this.price,
    required this.status,
    required this.date,
    required this.userId,
  });

  factory UserGetLotteryRespones.fromJson(Map<String, dynamic> json) =>
      UserGetLotteryRespones(
        number: json["number"],
        price: json["price"],
        status: json["status"],
        date: json["date"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
    "number": number,
    "price": price,
    "status": status,
    "date": date,
    "user_id": userId,
  };
}
