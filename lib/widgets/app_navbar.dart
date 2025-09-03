// lib/widgets/app_navbar.dart
import 'package:flutter/material.dart';

class AppNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFFCC737),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Shop"),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: "Basket",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
