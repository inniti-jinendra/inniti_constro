

import 'pr_items_model.dart';

class PrMasterModel {
  int userID;
  int plantID;
  String requisitionfor;
  String requiredByDate;
  String companyCode;
  List<PrItemsModel> prItems; // Change to a list

  PrMasterModel({
    required this.userID,
    required this.plantID,
    required this.requisitionfor,
    required this.requiredByDate,
    required this.companyCode,
    required this.prItems, // Change to a list
  });

  Map<String, dynamic> toJson() {
    return {
      "UserID": userID,
      "PlantID": plantID,
      "Requisitionfor": requisitionfor,
      "RequiredByDate": requiredByDate,
      "CompanyCode": companyCode,
      "pri": prItems
          .map((item) => item.toJson())
          .toList(), // Convert list of items to JSON
    };
  }

  factory PrMasterModel.fromJson(Map<String, dynamic> json) {
    return PrMasterModel(
      userID: json['UserID'],
      plantID: json['PlantID'],
      requisitionfor: json['Requisitionfor'] ?? '',
      requiredByDate: json['RequiredByDate'] ?? '',
      companyCode: json['CompanyCode'] ?? '',
      prItems: (json['pri'] as List<dynamic>)
          .map((item) => PrItemsModel.fromJson(item))
          .toList(),
    );
  }
}
