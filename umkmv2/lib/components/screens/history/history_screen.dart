// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Product {
  final String title;
  final String description;
  final String stok;
  final String type;
  final DateTime date;

  Product({
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    required this.stok,
  });
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Product>> _historyData;

  Future<List<Product>> fetchHistoryData() async {
    return [
      Product(
        title: 'Rinso',
        stok: '12',
        description:
            'Rinso Deterjen Cair, solusi terbaik untuk membersihkan pakaian Anda dengan sempurna.',
        type: 'masuk',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Product(
        title: 'Daia',
        stok: '12',
        description:
            'Daia Deterjen Cair, solusi pembersihan pakaian yang efektif dan terjangkau.',
        type: 'keluar',
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Product(
        title: 'Piring',
        stok: '12',
        description:
            'Piring keramik berkualitas tinggi, cocok untuk digunakan dalam setiap kesempatan makan.',
        type: 'masuk',
        date: DateTime.now().subtract(const Duration(days:2)),
      ),
      Product(
        title: 'Kopi',
        stok: '12',
        description:
            'Kopi bubuk pilihan, terbuat dari biji kopi terbaik yang dipanggang dengan sempurna untuk menghasilkan aroma yang kaya dan cita rasa yang mendalam. ',
        type: 'masuk',
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Product(
        title: 'Gula Pasir',
        stok: '12',
        description:
            ' Gula pasir berkualitas tinggi, cocok untuk kebutuhan rumah tangga dan bisnis.',
        type: 'keluar',
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _historyData = fetchHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: _historyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final historyData = snapshot.data!;
            DateTime? currentDate;

            return ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                final product = historyData[index];

                // Check if the date is different from the previous date
                if (currentDate == null ||
                    currentDate!.day != product.date.day) {
                  currentDate = product.date;

                  // Add a Divider above the ListTile
                  return Column(
                    children: [
                      const Divider(
                        thickness: 2,
                        indent: 16,
                        endIndent: 16,
                      ),
                      ListTile(
                        leading: Icon(
                          product.type == 'masuk'
                              ? Icons.arrow_circle_down
                              : Icons.arrow_circle_up,
                          color: product.type == 'masuk' ? Colors.green : Colors.red,
                        ),
                        title: Text(product.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Stok Tersedia:  ${product.stok}'),
                            Text(
                                DateFormat('dd MMM yyyy HH:mm').format(
                                    product.date)),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // Use a normal ListTile
                  return ListTile(
                    leading: Icon(
                      product.type == 'masuk'
                          ? Icons.arrow_circle_down
                          : Icons.arrow_circle_up,
                      color:
                          product.type == 'masuk' ? Colors.green : Colors.red,
                    ),
                    title: Text(product.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stok Tersedia:  ${product.stok}'),
                        Text(DateFormat('dd MMM yyyy HH:mm')
                            .format(product.date)),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}