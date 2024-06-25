// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'add_form.dart';
 
class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Tambah Produk'),
      ),
      body: const AddProductForm(),
    );
  }
}
