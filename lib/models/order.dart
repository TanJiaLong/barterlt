class Order {
  String? orderId;
  String? orderBill;
  String? orderItemId;
  String? orderQuantity;
  String? orderAmount;
  String? orderUserId;
  String? orderSellerId;
  String? orderStatus;
  String? orderLatitude;
  String? orderLongitude;
  String? orderDate;

  Order(
      {this.orderId,
      this.orderBill,
      this.orderItemId,
      this.orderQuantity,
      this.orderAmount,
      this.orderUserId,
      this.orderSellerId,
      this.orderStatus,
      this.orderLatitude,
      this.orderLongitude,
      this.orderDate});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderBill = json['orderBill'];
    orderItemId = json['orderItemId'];
    orderQuantity = json['orderQuantity'];
    orderAmount = json['orderAmount'];
    orderUserId = json['orderUserId'];
    orderSellerId = json['orderSellerId'];
    orderStatus = json['orderStatus'];
    orderLatitude = json['orderLatitude'];
    orderLongitude = json['orderLongitude'];
    orderDate = json['orderDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = orderId;
    data['orderBill'] = orderBill;
    data['orderItemId'] = orderItemId;
    data['orderQuantity'] = orderQuantity;
    data['orderAmount'] = orderAmount;
    data['orderUserId'] = orderUserId;
    data['orderSellerId'] = orderSellerId;
    data['orderStatus'] = orderStatus;
    data['orderLatitude'] = orderLatitude;
    data['orderLongitude'] = orderLongitude;
    data['orderDate'] = orderDate;
    return data;
  }
}
