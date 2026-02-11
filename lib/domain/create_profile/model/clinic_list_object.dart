class ClinicListObject {
  final String id;
  final String clinicName;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isSelected;

  ClinicListObject({
    required this.id,
    required this.clinicName,
    required this.createdAt,
    required this.updatedAt,
    required this.isSelected,
  });

  factory ClinicListObject.fromJson(Map<String, dynamic> json) {
    return ClinicListObject(
        id: json['id'],
        clinicName: json['clinicName'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        isSelected: false);
  }
}
