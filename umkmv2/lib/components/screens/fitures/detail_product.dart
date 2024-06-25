// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, must_be_immutable, unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_controllers.dart';
import '../../preferences/user.dart';
import '../../services/services_product.dart';

class ProductTitle extends StatelessWidget {
  final String title;
  const ProductTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Produk: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 22,
        ),
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductPrice extends StatelessWidget {
  final String price;
  const ProductPrice({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Harga: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 22,
        ),
        children: <TextSpan>[
          TextSpan(
            text: price,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDescription extends StatelessWidget {
  final String description;
  const ProductDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Deskripsi: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 22,
        ),
        children: <TextSpan>[
          TextSpan(
            text: description,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductStock extends StatelessWidget {
  final String stock;
  const ProductStock({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Stok Tersedia: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 22,
        ),
        children: <TextSpan>[
          TextSpan(
            text: '$stock pcs',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCode extends StatelessWidget {
  final String productCode;
  const ProductCode({super.key, required this.productCode});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Kode Produk: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 22,
        ),
        children: <TextSpan>[
          TextSpan(
            text: productCode,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateAt extends StatelessWidget {
  final DateTime created;
  const CreateAt({super.key, required this.created});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final formattedDate = dateFormatter.format(created);
    return RichText(
      text: TextSpan(
        text: 'Dibuat: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 22,
        ),
        children: <TextSpan>[
          TextSpan(
            text: formattedDate,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final int id;
  String title;
  late String price;
  late String description;
  late String stock;
  String productCode;
  final DateTime created;

  DetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.stock,
    required this.productCode,
    required this.created,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isEditing = false;
  late String _userId = '';
  late int _id;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _productCodeController;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _priceController = TextEditingController(text: widget.price);
    _stockController = TextEditingController(text: widget.stock);
    _productCodeController = TextEditingController(text: widget.productCode);
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    _userId = (await UserPreferences.getUserId()) ?? '';
    setState(() {});
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveChanges() async {
    try {
      if (_userId.isNotEmpty) {
        await ProductService().editProduct(
          _id,
          _userId,
          _titleController.text,
          _descriptionController.text,
          double.parse(_priceController.text),
          int.parse(_stockController.text),
          int.parse(_productCodeController.text),
        );

        Provider.of<ProductController>(context, listen: false).getProducts();

        _showSnackbar('Produk berhasil diperbarui', Colors.green);
        _toggleEditing();

        setState(() {
          widget.title = _titleController.text;
          widget.price = _priceController.text;
          widget.description = _descriptionController.text;
          widget.stock = _stockController.text;
          widget.productCode = _productCodeController.text;
        });
      }
    } catch (error) {
      _showSnackbar('Gagal memperbarui produk: $error', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save_as : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveChanges();
              } else {
                _toggleEditing();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          
        
            child: SingleChildScrollView(
             
                   child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(162, 76, 175, 79),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),  
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductTitle(title: widget.title),
                const SizedBox(height: 20),
                _isEditing
                    ? TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Harga',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : ProductPrice(price: widget.price),
                const SizedBox(height: 20),
                _isEditing
                    ? TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : ProductDescription(description: widget.description),
                const SizedBox(height: 20),
                _isEditing
                    ? TextFormField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Stok Tersedia',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : ProductStock(stock: widget.stock),
                const SizedBox(height: 20),
                ProductCode(productCode: widget.productCode),
                const SizedBox(height: 20),
                CreateAt(created: widget.created),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _productCodeController.dispose();
    super.dispose();
  }
}
