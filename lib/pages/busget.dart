import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:http/http.dart' as http;

class MyLotteriesPage extends StatefulWidget {
  const MyLotteriesPage({super.key, required this.userId});
  final int userId;

  @override
  State<MyLotteriesPage> createState() => _MyLotteriesPageState();
}

class _MyLotteriesPageState extends State<MyLotteriesPage> {
  bool _loading = true;
  String? _error;
  List<_BoughtItem> _items = [];
  String _base = '';
  int _totalPrize = 0; // รวมรางวัลที่ "ตรวจแล้ว" เท่านั้น

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((cfg) {
      setState(() => _base = (cfg['apiEndpoint'] ?? '').toString());
      _fetch();
    });
  }

  // รวมรางวัลที่ตรวจแล้ว
  void _recomputeTotalPrize() {
    final total = _items
        .where((e) => e.checked && e.winner)
        .fold<int>(0, (s, e) => s + e.prize);
    _totalPrize = total;
  }

  Future<void> _fetch() async {
    if (_base.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _totalPrize = 0;
    });

    final base = _base.endsWith('/')
        ? _base.substring(0, _base.length - 1)
        : _base;
    final uri = Uri.parse('$base/myreward?uid=${widget.userId}');

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final List list = (data['items'] ?? []) as List;
        final items = list
            .map((e) => _BoughtItem.fromJson(e as Map<String, dynamic>))
            .toList();
        setState(() {
          _items = items;
          _recomputeTotalPrize();
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _error = 'โหลดไม่สำเร็จ (${res.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'ผิดพลาด: $e';
      });
    }
  }

  // กดตรวจลอตเตอรี่ใบเดียว -> POST /check-ticket { uid, bid }
  Future<void> _checkTicket(_BoughtItem item) async {
    final base = _base.endsWith('/')
        ? _base.substring(0, _base.length - 1)
        : _base;
    final uri = Uri.parse('$base/check-ticket');

    try {
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({'uid': widget.userId, 'bid': item.bid}),
      );

      final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};

      if (res.statusCode == 200) {
        final bool winner =
            (body['winner'] == true) ||
            ((body['winner'] is num) && (body['winner'] as num).toInt() == 1);
        final int prize = (body['prize'] as num?)?.toInt() ?? 0;

        final idx = _items.indexWhere((e) => e.bid == item.bid);
        if (idx >= 0) {
          setState(() {
            _items[idx] = _items[idx].copyWith(
              checked: true, // status_buy = ตรวจแล้ว
              winner: winner,
              prize: prize,
            );
            _recomputeTotalPrize(); // อัปเดตยอดรวมบนหัว
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              winner
                  ? '🎉 ถูกรางวัล +$prize บาท (เติมเงินแล้ว)'
                  : 'เสียใจด้วย คุณไม่ถูกรางวัล',
            ),
          ),
        );
      } else {
        final msg = (body is Map && body['error'] is String)
            ? body['error']
            : 'ตรวจไม่สำเร็จ (${res.statusCode})';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$msg')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ผิดพลาด: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final header = SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ล็อตเตอรี่ที่ฉันซื้อแล้ว',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4CC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'รางวัลที่ได้สะสม: $_totalPrize บาท',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'รีเฟรช',
                  onPressed: _fetch,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _fetch, child: const Text('ลองใหม่')),
              ],
            ),
          )
        : _items.isEmpty
        ? const Center(child: Text('ยังไม่มีรายการซื้อ'))
        : RefreshIndicator(
            onRefresh: _fetch,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _BoughtCard(
                item: _items[i],
                onCheck: () => _checkTicket(_items[i]),
              ),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lotteries'),
        actions: [IconButton(onPressed: _fetch, icon: const Icon(Icons.sync))],
      ),
      body: Column(
        children: [
          header,
          Expanded(child: body),
        ],
      ),
    );
  }
}

// ------------------- Model -------------------

class _BoughtItem {
  final int bid;
  final int lid;
  final String number;
  final int price;
  final DateTime date;
  final bool winner; // มีรางวัลใน reward ไหม
  final int prize; // เงินรางวัล
  final bool checked; // status_buy: ตรวจแล้ว/ยังไม่ตรวจ

  _BoughtItem({
    required this.bid,
    required this.lid,
    required this.number,
    required this.price,
    required this.date,
    required this.winner,
    required this.prize,
    required this.checked,
  });

  factory _BoughtItem.fromJson(Map<String, dynamic> j) {
    bool _asChecked(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v.toInt() == 1;
      if (v is String) {
        final t = v.trim();
        final up = t.toUpperCase();
        return t == 'ตรวจแล้ว' ||
            up == 'CHECKED' ||
            up == 'TRUE' ||
            up == 'YES' ||
            up == 'Y' ||
            up == '1';
      }
      return false;
    }

    final dynamic rawChecked =
        j['status_buy'] ?? j['status'] ?? j['status_buy_int'];

    return _BoughtItem(
      bid: (j['bid'] as num).toInt(),
      lid: (j['lid'] as num).toInt(),
      number: (j['number'] ?? '').toString(),
      price: (j['price'] as num).toInt(),
      date: DateTime.parse(j['date'] as String),
      winner: (j['winner'] is bool)
          ? (j['winner'] as bool)
          : ((j['winner'] as num?)?.toInt() == 1),
      prize: (j['prize'] as num?)?.toInt() ?? 0,
      checked: _asChecked(rawChecked), // ✅ รองรับหลายรูปแบบ
    );
  }

  _BoughtItem copyWith({bool? winner, int? prize, bool? checked}) {
    return _BoughtItem(
      bid: bid,
      lid: lid,
      number: number,
      price: price,
      date: date,
      winner: winner ?? this.winner,
      prize: prize ?? this.prize,
      checked: checked ?? this.checked,
    );
  }
}

// ------------------- Card -------------------

class _BoughtCard extends StatelessWidget {
  const _BoughtCard({required this.item, required this.onCheck});
  final _BoughtItem item;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) {
    const kYellow = Color(0xFFFCC737);
    final won = item.winner && item.prize > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kYellow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // เลข 6 หลัก (เป็นช่อง ๆ)
          Row(
            children: List.generate(item.number.length, (i) {
              final d = item.number[i];
              return Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: EdgeInsets.only(
                      right: i == item.number.length - 1 ? 0 : 6,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      d,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),

          // บรรทัดข้อมูล
          Row(
            children: [
              Text(
                'ราคา ${item.price} บาท',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '#${item.lid}',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'ซื้อเมื่อ ${_fmt(item.date)}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),

          // แถบสถานะ + ปุ่มตรวจ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: item.checked
                    ? (won ? Colors.green : Colors.redAccent)
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  item.checked
                      ? (won ? Icons.verified : Icons.cancel)
                      : Icons.info_outline,
                  size: 18,
                  color: item.checked
                      ? (won ? Colors.green : Colors.redAccent)
                      : Colors.black54,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.checked
                        ? (won
                              ? '🎉 ถูกรางวัล +${item.prize} บาท (เติมเงินแล้ว)'
                              : 'เสียใจด้วย คุณไม่ถูกรางวัล')
                        : 'ยังไม่ตรวจ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: item.checked
                          ? (won ? Colors.green : Colors.redAccent)
                          : Colors.black87,
                    ),
                  ),
                ),
                if (!item.checked)
                  ElevatedButton(
                    onPressed: onCheck,
                    child: const Text('ตรวจลอตเตอรี่'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
  }
}
