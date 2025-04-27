class LabourGrid {
  final int labourId;
  final String labourCode;
  final String firstName;
  final String lastName;
  final String category;
  final String contactNo;
  final String profilePic;
  final String contractorName;
  final String totalWages;
  final String age;
  final String isActive;

  LabourGrid({
    required this.labourId,
    required this.labourCode,
    required this.firstName,
    required this.lastName,
    required this.category,
    required this.contactNo,
    required this.profilePic,
    required this.contractorName,
    required this.totalWages,
    required this.age,
    required this.isActive,
  });

  // Factory method to parse JSON into a Labour object
  factory LabourGrid.fromJson(Map<String, dynamic> json) {
    return LabourGrid(
      labourId: json['LABOUR_ID'],
      labourCode: json['LABOUR_CODE'] ?? '',
      firstName: json['LABOUR_FIRSTNAME'] ?? '',
      lastName: json['LABOUR_LASTNAME'] ?? '',
      category: json['LABOUR_CATEGORY'] ?? '',
      contactNo: json['LABOUR_CONTACTNO'] ?? '',
      profilePic: json['LABOUR_PROFILEPIC'] ?? '',
      contractorName: json['CONTRACTOR_NAME'] ?? '',
      totalWages: json['TOTALWAGES'] ?? '',
      age: json['LABOUR_AGE'] ?? "0",
      isActive: json['IS_ACTIVE'] ?? "",
    );
  }
}

List<Map<String, dynamic>> getDummyLabourJsonData() {
  return [
    {
      'LABOUR_ID': 1,
      'LABOUR_CODE': 'L001',
      'LABOUR_FIRSTNAME': 'John',
      'LABOUR_LASTNAME': 'Doe',
      'LABOUR_CATEGORY': 'Category A',
      'LABOUR_CONTACTNO': '1234567890',
      'LABOUR_PROFILEPIC': 'https://example.com/profile_pic1.png',
      'CONTRACTOR_NAME': 'Contractor A',
      'TOTALWAGES': '1500.00',
      'LABOUR_AGE': '28',
      'IS_ACTIVE': 'Active',
    },
    {
      'LABOUR_ID': 2,
      'LABOUR_CODE': 'L002',
      'LABOUR_FIRSTNAME': 'Alice',
      'LABOUR_LASTNAME': 'Smith',
      'LABOUR_CATEGORY': 'Category B',
      'LABOUR_CONTACTNO': '1234567891',
      'LABOUR_PROFILEPIC': 'https://example.com/profile_pic2.png',
      'CONTRACTOR_NAME': 'Contractor B',
      'TOTALWAGES': '1600.00',
      'LABOUR_AGE': '32',
      'IS_ACTIVE': 'In-Active',
    },
    {
      'LABOUR_ID': 3,
      'LABOUR_CODE': 'L003',
      'LABOUR_FIRSTNAME': 'Bob',
      'LABOUR_LASTNAME': 'Johnson',
      'LABOUR_CATEGORY': 'Category A',
      'LABOUR_CONTACTNO': '1234567892',
      'LABOUR_PROFILEPIC': 'https://example.com/profile_pic3.png',
      'CONTRACTOR_NAME': 'Contractor C',
      'TOTALWAGES': '1700.00',
      'LABOUR_AGE': '25',
      'IS_ACTIVE': 'Active',
    },
    {
      'LABOUR_ID': 4,
      'LABOUR_CODE': 'L004',
      'LABOUR_FIRSTNAME': 'Charlie',
      'LABOUR_LASTNAME': 'Williams',
      'LABOUR_CATEGORY': 'Category B',
      'LABOUR_CONTACTNO': '1234567893',
      'LABOUR_PROFILEPIC': 'https://example.com/profile_pic4.png',
      'CONTRACTOR_NAME': 'Contractor D',
      'TOTALWAGES': '1800.00',
      'LABOUR_AGE': '29',
      'IS_ACTIVE': 'In-Active',
    },
    {
      'LABOUR_ID': 5,
      'LABOUR_CODE': 'L005',
      'LABOUR_FIRSTNAME': 'Eve',
      'LABOUR_LASTNAME': 'Davis',
      'LABOUR_CATEGORY': 'Category A',
      'LABOUR_CONTACTNO': '1234567894',
      'LABOUR_PROFILEPIC': 'https://example.com/profile_pic5.png',
      'CONTRACTOR_NAME': 'Contractor E',
      'TOTALWAGES': '1900.00',
      'LABOUR_AGE': '27',
      'IS_ACTIVE': 'Active',
    },
    {
      'LABOUR_ID': 6,
      'LABOUR_CODE': 'L006',
      'LABOUR_FIRSTNAME': 'Frank',
      'LABOUR_LASTNAME': 'Miller',
      'LABOUR_CATEGORY': 'Category B',
      'LABOUR_CONTACTNO': '1234567895',
      'LABOUR_PROFILEPIC': 'https://example.com/profile_pic6.png',
      'CONTRACTOR_NAME': 'Contractor F',
      'TOTALWAGES': '2000.00',
      'LABOUR_AGE': '30',
      'IS_ACTIVE': 'In-Active',
    },
  ];
}
