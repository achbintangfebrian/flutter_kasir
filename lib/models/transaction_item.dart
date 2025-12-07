import 'base_model.dart';
import 'product.dart';

class TransactionItem extends BaseModel {
  int? transactionId;
  int? productId;
  int? quantity;
  int? price;
  int? subtotal;
  Product? product;

  TransactionItem({
    int? id,
    String? createdAt,
    String? updatedAt,
    this.transactionId,
    this.productId,
    this.quantity,
    this.price,
    this.subtotal,
    this.product,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'],
      transactionId: json['transaction_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: _parsePrice(json['price']),
      subtotal: _parsePrice(json['subtotal']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  /// Parse price from various possible JSON formats
  static int? _parsePrice(dynamic priceValue) {
    if (priceValue == null) return null;
    
    if (priceValue is int) {
      return priceValue;
    } else if (priceValue is double) {
      return priceValue.toInt();
    } else if (priceValue is String) {
      // Handle string representations like "5000000.00" or "5000000"
      try {
        // Try parsing as double first to handle decimal values
        final doubleValue = double.tryParse(priceValue);
        if (doubleValue != null) {
          return doubleValue.toInt();
        }
        return null;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['transaction_id'] = transactionId;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['subtotal'] = subtotal;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}