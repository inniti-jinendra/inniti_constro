class ItemAssignedDetails {
  int userId;
  String assignedDate;
  String itemName;
  String qty;
  String brandName;

  ItemAssignedDetails(
      {required this.userId,
      required this.assignedDate,
      required this.itemName,
      required this.qty,
      required this.brandName});

  factory ItemAssignedDetails.fromJson(Map<String, dynamic> json) {
    return ItemAssignedDetails(
      userId: json["UserID"],
      assignedDate: json["AssignedDate"],
      itemName: json["ItemName"],
      brandName: json["BrandName"],
      qty: json["Qty"],
    );
  }
}
