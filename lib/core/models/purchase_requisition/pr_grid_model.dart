class PrGrid {
  final int userID;
  final int purchaseRequisitionID;
  final String requisitionNo;
  final String requisitionDate;
  final String plantName;
  final String requestedBy;
  final String contactNumber;
  final String status;
  // final int rowNumber;
  final int totalCount;

  PrGrid({
    required this.userID,
    required this.purchaseRequisitionID,
    required this.requisitionNo,
    required this.requisitionDate,
    required this.plantName,
    required this.requestedBy,
    required this.contactNumber,
    required this.status,
    // required this.rowNumber,
    required this.totalCount,
  });

  // Factory method to parse JSON into a PR object
  factory PrGrid.fromJson(Map<String, dynamic> json) {
    return PrGrid(
      userID: json['UserID'],
      purchaseRequisitionID: json['PurchaseRequisitionID'] ?? '',
      requisitionNo: json['RequisitionNo'] ?? '',
      requisitionDate: json['RequisitionDate'] ?? '',
      plantName: json['PlantName'] ?? '',
      requestedBy: json['RequestedBy'] ?? '',
      contactNumber: json['ContactNumber'] ?? '',
      status: json['Status'] ?? '',
      // rowNumber: json['RowNumber'] ?? '',
      totalCount: json['TotalCount'] ?? "0",
    );
  }
}
