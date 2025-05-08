

class Project {
  final int plantId;
  final String plantName;

  Project({required this.plantId, required this.plantName});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      plantId: json['PlantID'],
      plantName: json['PlantName'],
    );
  }
}
