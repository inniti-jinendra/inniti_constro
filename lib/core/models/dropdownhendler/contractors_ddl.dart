class ContractorItem {
  final int contractorID;
  final String contractorName;

  ContractorItem({
    required this.contractorID,
    required this.contractorName,
  });

  factory ContractorItem.fromJson(Map<String, dynamic> json) {
    return ContractorItem(
      contractorID: json['ContractorID'],
      contractorName: json['ContractorName'],
    );
  }
}
