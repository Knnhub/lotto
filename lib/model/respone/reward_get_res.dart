// To parse this JSON data, do
//
//     final rewardGetResponse = rewardGetResponseFromJson(jsonString);

import 'dart:convert';

List<RewardGetResponse> rewardGetResponseFromJson(String str) =>
    List<RewardGetResponse>.from(
      json.decode(str).map((x) => RewardGetResponse.fromJson(x)),
    );

String rewardGetResponseToJson(List<RewardGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RewardGetResponse {
  int rid;
  int money;
  String type;
  int lotteryId;
  String number;

  RewardGetResponse({
    required this.rid,
    required this.money,
    required this.type,
    required this.lotteryId,
    required this.number,
  });

  factory RewardGetResponse.fromJson(Map<String, dynamic> json) =>
      RewardGetResponse(
        rid: json["rid"],
        money: json["money"],
        type: json["type"],
        lotteryId: json["lottery_id"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
    "rid": rid,
    "money": money,
    "type": type,
    "lottery_id": lotteryId,
    "number": number,
  };
}
