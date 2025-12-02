import 'base_model.dart';

class Customer extends BaseModel {
  String? name;
  String? phone;

  Customer({
    int? id,
    String? createdAt,
    String? updatedAt,
    this.name,
    this.phone,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}