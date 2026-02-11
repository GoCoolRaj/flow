import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateFabricRequest {
  final String prompt;
  final String fabricId;
  final String? imagePath;
  final String userId;

  CreateFabricRequest({
    required this.prompt,
    required this.fabricId,
    this.imagePath,
    required this.userId,
  });

  FormData toFormData() {
    debugPrint("Imagepath$imagePath", wrapWidth: 1024);
    return FormData.fromMap({
      'prompt': prompt,
      'fabricId': fabricId,
      'userId': userId,
      if (imagePath != null)
        'image': MultipartFile.fromFileSync(
          imagePath!,
        ),
    });
  }
}
