import 'package:mobile_food_delivery/models/order_detail.dart';

enum OrderStatus { HAVE_NOT_STARTED, IN_PROCESS, DONE, CANCEL }

class Order {
  String? orderId;
  bool haveDeposit;
  String orderName;
  double totalPrice;
  double advance;
  double remaining;
  OrderStatus status;
  String userId;
  String tableId;
  List<OrderDetail> orderDetails;

  Order({
    this.orderId,
    required this.haveDeposit,
    required this.orderName,
    required this.totalPrice,
    required this.advance,
    required this.remaining,
    required this.status,
    required this.userId,
    required this.tableId,
    this.orderDetails = const [],
  });
  Order copyWith({
    String? orderId,
    bool? haveDeposit,
    String? orderName,
    double? totalPrice,
    double? advance,
    double? remaining,
    OrderStatus? status,
    String? userId,
    String? tableId,
    List<OrderDetail>? orderDetails,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      haveDeposit: haveDeposit ?? this.haveDeposit,
      orderName: orderName ?? this.orderName,
      totalPrice: totalPrice ?? this.totalPrice,
      advance: advance ?? this.advance,
      remaining: remaining ?? this.remaining,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      tableId: tableId ?? this.tableId,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] ?? '',
      haveDeposit: json['haveDeposit'] ?? false,
      orderName: json['orderName'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      advance: (json['advance'] ?? 0).toDouble(),
      remaining: (json['remaining'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status'] ?? 'HAVE_NOT_STARTED'}',
        orElse: () => OrderStatus.HAVE_NOT_STARTED,
      ),
      userId: json['userId'] ?? '',
      tableId: json['tableId'] ?? '',
      orderDetails:
          (json['orderDetails'] as List?)?.map((e) => OrderDetail.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'haveDeposit': haveDeposit,
      'orderName': orderName,
      'totalPrice': totalPrice,
      'advance': advance,
      'remaining': remaining,
      'status': status.toString().split('.').last,
      'userId': userId,
      'tableId': tableId,
      'orderDetails': orderDetails.map((e) => e.toJson()).toList(),
    };
  }
}
