class SuppliersDDL {
  final int id;
  final String name;

  SuppliersDDL({required this.id, required this.name});

  factory SuppliersDDL.fromJson(Map<String, dynamic> json) {
    return SuppliersDDL(
      id: json['ContractorID'],
      name: json['ContractorName'],
    );
  }
}

class LabourCategoryDLL {
  final String id;
  final String name;

  LabourCategoryDLL({required this.id, required this.name});

  factory LabourCategoryDLL.fromJson(Map<String, dynamic> json) {
    return LabourCategoryDLL(
      id: json['GeneralDropDownText'],
      name: json['GeneralDropDownValue'],
    );
  }
}

class CurrencyDDL {
  final int id;
  final String code;

  CurrencyDDL({required this.id, required this.code});

  factory CurrencyDDL.fromJson(Map<String, dynamic> json) {
    return CurrencyDDL(
      id: json['CurrencyID'],
      code: json['Currency'],
    );
  }
}

class ItemsDDL {
  final int id;
  final String itemName;

  ItemsDDL({required this.id, required this.itemName});

  factory ItemsDDL.fromJson(Map<String, dynamic> json) {
    return ItemsDDL(
      id: json['ItemID'],
      itemName: json['ItemName'],
    );
  }
}

class ItemBrandDDL {
  final int itemBrandID;
  final String itemBrandName;

  ItemBrandDDL({required this.itemBrandID, required this.itemBrandName});

  factory ItemBrandDDL.fromJson(Map<String, dynamic> json) {
    return ItemBrandDDL(
      itemBrandID: json['ItemBrandID'],
      itemBrandName: json['ItemBrandName'],
    );
  }
}

class ItemUOM {
  final int itemUOMID;
  final String itemUOMName;

  ItemUOM({required this.itemUOMID, required this.itemUOMName});

  factory ItemUOM.fromJson(Map<String, dynamic> json) {
    return ItemUOM(
      itemUOMID: json['ItemUomID'],
      itemUOMName: json['UOMName'],
    );
  }
}
