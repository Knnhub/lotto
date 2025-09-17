import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/respone/reward_get_res.dart';
import 'package:flutter_application_1/pages/busget.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/shop.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LotteryScreen extends StatefulWidget {
  final int uid;
  const LotteryScreen({super.key, required this.uid});

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
  int _currentIndex = 0;
  String _apiEndpoint = '';
  Future<List<RewardGetResponse>>? _rewardsFuture;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await Configuration.getConfig();
    setState(() {
      _apiEndpoint = config['apiEndpoint'] ?? '';
      _rewardsFuture = _fetchRewards();
    });
  }

  Future<List<RewardGetResponse>> _fetchRewards() async {
    final url = '$_apiEndpoint/reward/get';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return rewardGetResponseFromJson(response.body);
    } else {
      throw Exception("Failed to load rewards (${response.statusCode})");
    }
  }

  void _onNavTapped(int index) {
    if (index == 4) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      if (_rewardsFuture == null)
        const Center(child: CircularProgressIndicator())
      else
        LotteryScreenContent(rewardsFuture: _rewardsFuture!),
      Shop(uid: widget.uid),
      Profile(uid: widget.uid),
      MyLotteriesPage(userId: widget.uid),
    ];

    return Scaffold(
      extendBody: true,
      body: pages[_currentIndex],
      bottomNavigationBar: Material(
        color: const Color(0xFFFCC737),
        elevation: 8,
        child: SafeArea(
          top: false,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: const Color(0xFFFCC737),
              indicatorColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                (states) => IconThemeData(
                  size: states.contains(WidgetState.selected) ? 26 : 24,
                  color: Colors.black.withOpacity(
                    states.contains(WidgetState.selected) ? 1 : 0.7,
                  ),
                ),
              ),
              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (states) => TextStyle(
                  fontWeight: states.contains(WidgetState.selected)
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            child: NavigationBar(
              height: 64,
              selectedIndex: _currentIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: _onNavTapped,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  selectedIcon: Icon(Icons.shopping_bag),
                  label: 'Shop',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'My Lottery',
                ),
                NavigationDestination(
                  icon: Icon(Icons.logout_outlined),
                  selectedIcon: Icon(Icons.logout),
                  label: 'Logout',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LotteryScreenContent extends StatelessWidget {
  final Future<List<RewardGetResponse>> rewardsFuture;
  const LotteryScreenContent({super.key, required this.rewardsFuture});

  Future<void> _onCheckPressed(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber),
            const SizedBox(width: 8),
            Text(
              'ยินดีด้วย!',
              style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'ระบบตรวจเสร็จแล้ว (เดโม่)\n— ตรงนี้ใส่ผลจริงตามที่ต้องการได้',
          style: GoogleFonts.kanit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('ปิด', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom + 96;

    return SafeArea(
      child: FutureBuilder<List<RewardGetResponse>>(
        future: rewardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'โหลดข้อมูลไม่สำเร็จ\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kanit(fontSize: 16),
                ),
              ),
            );
          }

          final rewards = snapshot.data ?? const <RewardGetResponse>[];

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ตรวจผลสลาก
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'ตรวจผลสลาก',
                        style: GoogleFonts.kanit(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'งวดวันที่ 1 สิงหาคม 2568',
                        style: GoogleFonts.kanit(color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                          6,
                          (i) => Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCC737),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '1',
                              style: GoogleFonts.kanit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFCC737),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => _onCheckPressed(context),
                          child: Text(
                            'ตรวจสลากของคุณ',
                            style: GoogleFonts.kanit(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // รางวัลที่ 1 (ตัวอย่าง)
                _PrizeSection(
                  title: 'รางวัลที่ 1',
                  numberBoxes: const ['4', '5', '1', '4', '4', '0'],
                  prizeText: '6,000,000 บาท',
                ),
                const SizedBox(height: 12),
                // รางวัลอื่น ๆ แบบ grid
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  children: const [
                    _MiniPrizeCard(
                      title: 'รางวัลที่ 2',
                      number: '769601',
                      prize: '200,000 บาท',
                    ),
                    _MiniPrizeCard(
                      title: 'รางวัลที่ 3',
                      number: '390356',
                      prize: '80,000 บาท',
                    ),
                    _MiniPrizeCard(
                      title: 'เลขท้าย 2 ตัว',
                      number: '66',
                      prize: '2,000 บาท',
                    ),
                    _MiniPrizeCard(
                      title: 'เลขท้าย 3 ตัว',
                      number: '348',
                      prize: '4,000 บาท',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PrizeSection extends StatelessWidget {
  final String title;
  final List<String> numberBoxes;
  final String prizeText;
  const _PrizeSection({
    required this.title,
    required this.numberBoxes,
    required this.prizeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.kanit(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: numberBoxes
                .map(
                  (n) => Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCC737),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      n,
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          FittedBox(
            child: Text(
              prizeText,
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPrizeCard extends StatelessWidget {
  final String title;
  final String number;
  final String prize;
  const _MiniPrizeCard({
    required this.title,
    required this.number,
    required this.prize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Center(
              child: FittedBox(
                child: Text(
                  number,
                  style: GoogleFonts.kanit(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(prize, style: GoogleFonts.kanit(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
