import 'base_model.dart';
import 'customer.dart';
import 'transaction_item.dart';

class Transaction extends BaseModel {
  int? customerId;
  int? total;
  Customer? customer;
  List<TransactionItem>? items;

  Transaction({
    int? id,
    String? createdAt,
    String? updatedAt,
    this.customerId,
    this.total,
    this.customer,
    this.items,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    List<TransactionItem>? itemsList;
    if (json['items'] != null) {
      itemsList = <TransactionItem>[];
      json['items'].forEach((v) {
        itemsList!.add(TransactionItem.fromJson(v));
      });
    }

    return Transaction(
      id: json['id'],
      customerId: json['customer_id'],
      total: json['total'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      items: itemsList,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['customer_id'] = customerId;
    data['total'] = total;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}