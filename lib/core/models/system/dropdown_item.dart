class Contractor {
  final String id;
  final String name;

  Contractor({required this.id, required this.name});
}


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

  // Custom toString method to log the object in a readable format
  @override
  String toString() {
    return 'ContractorID: $id, ContractorName: $name';
  }

}

class LabourCategoryDLL {
  final String id;
  final String name;

  LabourCategoryDLL({
    required this.id,
    required this.name,
  });

  // Fixing potential null values using null-aware operator (?? '')
  factory LabourCategoryDLL.fromJson(Map<String, dynamic> json) {
    return LabourCategoryDLL(
      id: json['LabourCategoryValue'] ?? '',  // Ensure 'id' is not null
      name: json['LabourCategoryText'] ?? '', // Ensure 'name' is not null
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
