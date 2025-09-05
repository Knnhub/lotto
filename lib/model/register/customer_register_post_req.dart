// To parse this JSON data, do
//
//     final customerRegisterPostResponse = customerRegisterPostResponseFromJson(jsonString);

import 'dart:convert';

CustomerRegisterPostResponse customerRegisterPostResponseFromJson(String str) =>
    CustomerRegisterPostResponse.fromJson(json.decode(str));

String customerRegisterPostResponseToJson(CustomerRegisterPostResponse data) =>
    json.encode(data.toJson());

class CustomerRegisterPostResponse {
  int uid;
  String fullName;
  String email;
  String phone;
  String role;
  int money;

  CustomerRegisterPostResponse({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.money,
  });

  factory CustomerRegisterPostResponse.fromJson(Map<String, dynamic> json) =>
      CustomerRegisterPostResponse(
        uid: json["uid"],
        fullName: json["full_name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "full_name": fullName,
    "email": email,
    "phone": phone,
    "role": role,
    "money": money,
  };
}
