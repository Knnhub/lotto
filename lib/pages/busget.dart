import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 1637.15,
        height: 850,
        child: Stack(
          children: [
            // Frame 5 (Sidebar)
            Positioned(
              left: 0,
              top: 0,
              child: Container(width: 410.31, height: 850, color: Colors.white),
            ),

            // Rectangle 19 (bottom bar background)
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 410.31,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCC737),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(1, -2),
                      blurRadius: 10,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
            ),

            // Home
            Positioned(
              left: 25,
              bottom: 6,
              child: const Text(
                "Home",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),

            // Shop
            Positioned(
              left: 108,
              bottom: 6,
              child: const Text(
                "Shop",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),

            // Basket
            Positioned(
              left: 253,
              bottom: 6,
              child: const Text(
                "Basket",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),

            // Logout
            Positioned(
              left: 326,
              bottom: 5,
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),

            // Title
            const Positioned(
              left: 73,
              top: 69,
              child: Text(
                "ตะกร้าสินค้าของฉัน",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
