class PrItemsModel {
  String itemID;
  String itemDescription;
  String itemUOMID;
  String quantity;
  String itemBrandID;

  PrItemsModel({
    required this.itemID,
    required this.itemDescription,
    required this.itemUOMID,
    required this.quantity,
    required this.itemBrandID,
  });

  Map<String, dynamic> toJson() {
    return {
      "ItemID": itemID,
      "ItemDescription": itemDescription,
      "ItemUOMID": itemUOMID,
      "Quantity": quantity,
      "ItemBrandID": itemBrandID,
    };
  }

  factory PrItemsModel.fromJson(Map<String, dynamic> json) {
    return PrItemsModel(
      itemID: json['ItemID'],
      itemDescription: json['ItemDescription'],
      itemUOMID: json['ItemUOMID'] ?? '',
      quantity: json['Quantity'] ?? '',
      itemBrandID: json['ItemBrandID'],
    );
  }
}
