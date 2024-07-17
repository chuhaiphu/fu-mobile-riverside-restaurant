enum Status { HAVE_NOT_STARTED, IN_PROCESS, DONE, CANCEL }

class OrderDetail {
  String? orderDetailId;
  String orderId;
  String dishId;
  String description;
  Status status;
  int quantity;
  String? personSaveId;

  OrderDetail({
    this.orderDetailId,
    required this.orderId,
    required this.dishId,
    required this.description,
    required this.status,
    required this.quantity,
    required this.personSaveId,
  });

factory OrderDetail.fromJson(Map<String, dynamic> json) {
  return OrderDetail(
    orderDetailId: json['orderDetailId'] as String?,
    orderId: json['orderId'] as String,
    dishId: json['dishId'] as String,
    description: json['description'] as String,
    status: Status.values.firstWhere(
      (e) => e.toString() == 'Status.${json['status']}',
      orElse: () => Status.HAVE_NOT_STARTED,
    ),
    quantity: json['quantity'] as int,
    personSaveId: json['lastModifiedBy'] as String? ?? json['personSaveId'] as String?,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'orderDetailId': orderDetailId,
      'orderId': orderId,
      'dishId': dishId,
      'description': description,
      'status': status.toString().split('.').last,
      'quantity': quantity,
      'personSaveId': personSaveId,
    };
  }
}
