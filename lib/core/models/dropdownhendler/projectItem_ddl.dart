
class ProjectItem {
  final String projectItemTypeName;
  final int projectItemTypeId;

  ProjectItem({required this.projectItemTypeName, required this.projectItemTypeId});

  // Method to parse API response into ProjectItem list
  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      projectItemTypeName: json['ProjectItemTypeName'] ?? '',
      projectItemTypeId: json['ProjectItemTypeID'] ?? 0,
    );
  }
}
