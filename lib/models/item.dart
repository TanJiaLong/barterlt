class Item {
  String? itemId;
  String? userId;
  String? itemName;
  String? itemDesc;
  String? itemCategory;
  String? itemQuantity;
  String? itemValue;
  String? state;
  String? locality;
  String? latitude;
  String? longitude;
  String? regDate;

  Item(
      {this.itemId,
      this.userId,
      this.itemName,
      this.itemDesc,
      this.itemCategory,
      this.itemQuantity,
      this.itemValue,
      this.state,
      this.locality,
      this.latitude,
      this.longitude,
      this.regDate});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    itemName = json['item_name'];
    itemDesc = json['item_desc'];
    itemCategory = json['item_category'];
    itemQuantity = json['item_quantity'];
    itemValue = json['item_value'];
    state = json['state'];
    locality = json['locality'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    regDate = json['reg_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = itemId;
    data['user_id'] = userId;
    data['item_name'] = itemName;
    data['item_desc'] = itemDesc;
    data['item_category'] = itemCategory;
    data['item_quantity'] = itemQuantity;
    data['item_value'] = itemValue;
    data['state'] = state;
    data['locality'] = locality;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['reg_date'] = regDate;
    return data;
  }
}
