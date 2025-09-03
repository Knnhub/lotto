import 'package:flutter/material.dart';

class AdminRanNum extends StatelessWidget {
  const AdminRanNum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFFCC737),
          ),

          /// group_17
          Positioned(
            left: 25,
            top: 104,
            child: Container(width: 350, height: 150, color: Colors.white),
          ),

          /// group_18
          Positioned(
            left: 25,
            top: 275,
            child: Container(width: 350, height: 150, color: Colors.white),
          ),

          /// group_20
          Positioned(
            left: 25,
            top: 452,
            child: Container(width: 350, height: 150, color: Colors.white),
          ),

          /// group_22
          Positioned(
            left: 25,
            top: 629,
            child: Container(width: 350, height: 150, color: Colors.white),
          ),

          /// group_8
          Positioned(
            left: 275,
            top: 18,
            child: Container(width: 100, height: 50, color: Colors.transparent),
          ),

          /// สุ่มทั้งหมด
          Positioned(
            left: 286,
            top: 31,
            child: Text(
              "สุ่มทั้งหมด",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: "Inter",
              ),
            ),
          ),

          /// งวดวันที่
          Positioned(
            left: 25,
            top: 38,
            child: Text(
              "งวดวันที่ 1 สิงหาคม 2568",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontFamily: "Roboto",
              ),
            ),
          ),

          /// Bottom Nav
          Positioned(
            left: 47,
            top: 826,
            child: Text(
              "Home",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Positioned(
            left: 179,
            top: 826,
            child: Text(
              "Reset",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Positioned(
            left: 303,
            top: 826,
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
