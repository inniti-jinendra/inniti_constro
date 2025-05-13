// Dummy data for each month
final Map<String, List<Map<String, String>>> monthData = {
  "Apr": [
    {
      "tds": "10.00 Ltr.",
      "date": "14/04/2025",
      "supplier": "A TO Z DANTING WELDING WORKS"
    },
    {
      "tds": "30.00 Ltr.",
      "date": "10/04/2025",
      "supplier": "INDIAN OIL PVT LTD"
    },
  ],
  "May": [
    {
      "tds": "10.00 Ltr.",
      "date": "14/04/2025",
      "supplier": "A TO Z DANTING WELDING WORKS"
    },
    {
      "tds": "30.00 Ltr.",
      "date": "10/04/2025",
      "supplier": "INDIAN OIL PVT LTD"
    },  {
      "tds": "30.00 Ltr.",
      "date": "10/04/2025",
      "supplier": "INDIAN OIL PVT LTD"
    },
  ],
};



class FuelPurchase {
  final int dieselID;
  final String plantName;
  final String grnNumber;
  final String supplierName;
  final DateTime purchaseDate;
  final double unit;
  final String itemName;
  final double totalUnit;
  final int totalCount;

  FuelPurchase({
    required this.dieselID,
    required this.plantName,
    required this.grnNumber,
    required this.supplierName,
    required this.purchaseDate,
    required this.unit,
    required this.itemName,
    required this.totalUnit,
    required this.totalCount,
  });

  factory FuelPurchase.fromJson(Map<String, dynamic> json) {
    return FuelPurchase(
      dieselID: json['DieselID'] ?? 0,
      plantName: json['PlantName'] ?? '',
      grnNumber: json['GRNNumber'] ?? '',
      supplierName: json['SupplierName'] ?? '',
      purchaseDate: DateTime.parse(json['PurchaseDate']),
      unit: (json['Unit'] as num).toDouble(),
      itemName: json['ItemName'] ?? '',
      totalUnit: (json['TotalUnit'] as num).toDouble(),
      totalCount: json['TotalCount'] ?? 0,
    );
  }
}
