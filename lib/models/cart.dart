class Cart {
  String? cartId;
  String? cartItemId;
  String? cartQuantity;
  String? cartPrice;
  String? cartUserId;
  String? cartSellerId;
  String? cartDate;

  Cart({
    this.cartId,
    this.cartItemId,
    this.cartQuantity,
    this.cartPrice,
    this.cartUserId,
    this.cartSellerId,
    this.cartDate,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    cartItemId = json['cart_itemId'];
    cartQuantity = json['cart_quantity'];
    cartPrice = json['cart_price'];
    cartUserId = json['cart_userId'];
    cartSellerId = json['cart_sellerId'];
    cartDate = json['cart_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['catch_id'] = cartItemId;
    data['catch_name'] = cartQuantity;
    data['catch_status'] = cartPrice;
    data['catch_type'] = cartUserId;
    data['catch_desc'] = cartSellerId;
    data['catch_qty'] = cartDate;
    return data;
  }
}
