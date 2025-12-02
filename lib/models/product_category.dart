import 'base_model.dart';

class ProductCategory extends BaseModel {
  String? name;

  ProductCategory({int? id, String? createdAt, String? updatedAt, this.name})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['name'] = name;
    return data;
  }
}