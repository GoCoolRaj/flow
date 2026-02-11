import 'package:dio/dio.dart';
import 'package:quilt_flow_app/domain/create_profile/model/create_profile_image_request.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/check_fabric_image_response.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/check_fabric_images_request.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/create_fabric_request.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/create_fabric_response.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/save_fabric_request.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/save_fabric_response.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/unique_fabric_request.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/unique_fabric_response.dart';

abstract class FabricGenRepository {
  Future<CreateFabricResponse> createFabric(CreateFabricRequest request);
  Future<CreateFabricResponse> createProfileImageFabric(
    CreateProfileImageRequest request,
  );
  Future<SaveFabricResponse> saveFabric(SaveFabricRequest request);
  Future<UniqueFabricResponse> isFabricUnique(
    UniqueFabricRequest request, {
    CancelToken? cancelToken,
  });
  Future<CheckFabricImageResponse> checkFabricImages(
    CheckFabricImagesRequest request,
  );
}
