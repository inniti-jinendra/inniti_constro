class PoGrid {
  final int poId;
  final String poNumber;
  final String supplierName;
  final String status;
  final String orderDate;
  final String totalAmount;

  PoGrid({
    required this.poId,
    required this.poNumber,
    required this.supplierName,
    required this.status,
    required this.orderDate,
    required this.totalAmount,
  });

  factory PoGrid.fromJson(Map<String, dynamic> json) {
    return PoGrid(
        poId: json['PurchaseOrderID'],
        poNumber: json['PurchaseOrderNo'] ?? '',
        supplierName: json['SupplierName'] ?? '',
        status: json['Status'] ?? '',
        orderDate: json['OrderDate'] ?? '',
        totalAmount: json['Amount'] ?? '');
  }
}

class POGridItems {
  final String itemName;
  final String orderQuantity;
  final String pendingQuantity;

  POGridItems({
    required this.itemName,
    required this.orderQuantity,
    required this.pendingQuantity,
  });

  factory POGridItems.fromJson(Map<String, dynamic> json) {
    return POGridItems(
      itemName: json['ItemName'] ?? '',
      orderQuantity: json['OrderQnt'] ?? '0',
      pendingQuantity: json['RemainingWeight'] ?? '0',
    );
  }
}
