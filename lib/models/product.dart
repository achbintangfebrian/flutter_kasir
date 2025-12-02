import 'base_model.dart';
import 'product_category.dart';

class Product extends BaseModel {
  String? name;
  int? price;
  int? stock;
  int? categoryId;
  ProductCategory? category;

  Product({
    int? id,
    String? createdAt,
    String? updatedAt,
    this.name,
    this.price,
    this.stock,
    this.categoryId,
    this.category,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
      categoryId: json['category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['name'] = name;
    data['price'] = price;
    data['stock'] = stock;
    data['category_id'] = categoryId;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}