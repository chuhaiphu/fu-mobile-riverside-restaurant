class Payment {
  String? paymentId;
  double price;
  DateTime paymentTime;
  bool isAvailable;
  String orderId;

  Payment({
    this.paymentId,
    required this.price,
    required this.paymentTime,
    required this.isAvailable,
    required this.orderId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['paymentId'],
      price: (json['price'] ?? 0).toDouble(),
      paymentTime: DateTime.parse(json['paymentTime'] ?? ''),
      isAvailable: json['isAvailable'] ?? false,
      orderId: json['orderId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'price': price,
      'paymentTime': paymentTime.toIso8601String(),
      'isAvailable': isAvailable,
      'orderId': orderId,
    };
  }
}
