// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class AdminRanNum extends StatelessWidget {
// //   const AdminRanNum({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,

// //       // ✅ ใช้ AppBar แทน Container ที่คุณทำเอง
// //       appBar: AppBar(
// //         backgroundColor: const Color(0xFFFCC737),
// //         automaticallyImplyLeading: false, // 🚫 ไม่ต้องสร้างปุ่ม back อัตโนมัติ
// //         title: Text(
// //           "สุ่มล็อตเตอรี่",
// //           style: GoogleFonts.kanit(
// //             fontSize: 24,
// //             color: Colors.black,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         centerTitle: true, // จัดให้ title อยู่ตรงกลาง
// //         elevation: 0, // ลบเงาขอบล่าง
// //       ),

// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: Column(
// //             children: [
// //               Align(
// //                 alignment: Alignment.centerRight, // ชิดขวา
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     // ใส่ฟังก์ชันที่จะทำเมื่อกดปุ่ม
// //                     print("กดปุ่มแล้ว!");
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFFFCC737), // สีพื้นหลัง
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 16,
// //                       vertical: 16,
// //                     ),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(
// //                         16,
// //                       ), // มุมโค้งเหมือน Container เดิม
// //                     ),
// //                   ),
// //                   child: Text(
// //                     "สุ่มทั้งหมด",
// //                     style: GoogleFonts.kanit(
// //                       fontSize: 16,
// //                       color: Colors.black,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AdminRanNum extends StatelessWidget {
//   const AdminRanNum({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ตัวอย่างเลขล็อตเตอรี่
//     final lotteryNumbers = ['123456', '654321', '112233'];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFCC737),
//         automaticallyImplyLeading: false,
//         title: Text(
//           "สุ่มล็อตเตอรี่",
//           style: GoogleFonts.kanit(
//             fontSize: 24,
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               // ปุ่มสุ่มทั้งหมด ชิดขวา
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     print("กดปุ่มสุ่มทั้งหมด!");
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFCC737),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 16,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: Text(
//                     "สุ่มทั้งหมด",
//                     style: GoogleFonts.kanit(
//                       fontSize: 16,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // การ์ดล็อตเตอรี่
//               Column(
//                 children: lotteryNumbers.map((number) {
//                   return lotteryCard(number);
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ฟังก์ชันสร้างการ์ดล็อตเตอรี่
//   Widget lotteryCard(String number) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//       color: const Color(0xFFFCC737),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // ราคา + ปุ่ม (ยังไม่ทำงาน)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '80 บาท',
//                   style: GoogleFonts.kanit(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: null, // ยังไม่ทำงาน
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     disabledBackgroundColor: Colors.white70,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                   ),
//                   child: Text(
//                     'ซื้อล็อตเตอรี่',
//                     style: GoogleFonts.kanit(
//                       fontSize: 14,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // กล่องเลข 6 หลัก
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: number.split('').map((digit) {
//                 return Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     digit,
//                     style: GoogleFonts.kanit(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
