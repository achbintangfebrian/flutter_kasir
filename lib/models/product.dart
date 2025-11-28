class Product {
  final int id;
  final String name;
  final int price;
  final int stock;
  final int categoryId;
  final String? image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.categoryId,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['nama'] ?? '',
      price: json['harga'] ?? 0,
      stock: json['stok'] ?? 0,
      categoryId: json['kategori_id'] ?? 0,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nama': name,
      'harga': price,
      'stok': stock,
      'kategori_id': categoryId,
    };
    if (image != null) {
      data['image'] = image!;
    }
    return data;
  }
}