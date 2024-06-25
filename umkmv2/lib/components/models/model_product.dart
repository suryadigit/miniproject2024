class ProductModel {
  final int id;
  final String title;
  final DateTime created;
  final String price;
  final String stock;
  final String productCode;
  final String description;

  ProductModel({
    required this.id,
    required this.title,
    required this.created,
    required this.price,
    required this.stock,
    required this.productCode,
    required this.description,
  });

  // function fromJson
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      created: DateTime.parse(json['created']),
      title: json['title'],
      price: json['price'],
      stock: json['stock'],
      productCode: json['productCode'],
      description: json['description'],
    );
  }

  // function toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'stock': stock,
      'productCode': productCode,
      'description': description,
    };
  }
}
