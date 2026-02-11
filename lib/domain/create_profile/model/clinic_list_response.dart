import 'package:quilt_flow_app/domain/create_profile/model/clinic_list_object.dart';

class ClinicListResponse {
  List<ClinicListObject>? clinicList;
  String? message;
  int? statusCode;

  ClinicListResponse({
    required this.message,
    required this.statusCode,
    this.clinicList,
  });

  factory ClinicListResponse.fromJson(List json) {
    return ClinicListResponse(
      message: "",
      statusCode: 200,
      clinicList: _parseClinicList(json),
    );
  }
  static List<ClinicListObject> _parseClinicList(dynamic data) {
    if (data == null) return [];
    return List<ClinicListObject>.from(
      data.map((item) => ClinicListObject.fromJson(item)),
    );
  }
}
