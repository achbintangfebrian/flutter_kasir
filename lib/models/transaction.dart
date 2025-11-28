class Transaction {
  final int id;
  final int userId;
  final String paymentMethod;
  final List<TransactionItem> items;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.paymentMethod,
    required this.items,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<TransactionItem> items = itemsList.map((i) => TransactionItem.fromJson(i)).toList();

    return Transaction(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      paymentMethod: json['payment_method'] ?? '',
      items: items,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'payment_method': paymentMethod,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TransactionItem {
  final int productId;
  final int quantity;
  final double pricePerItem;
  final double subtotal;

  TransactionItem({
    required this.productId,
    required this.quantity,
    required this.pricePerItem,
    required this.subtotal,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      pricePerItem: (json['price_per_item'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price_per_item': pricePerItem,
      'subtotal': subtotal,
    };
  }
}