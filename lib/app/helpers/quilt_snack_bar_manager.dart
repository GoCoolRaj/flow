import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quilt_flow_app/app/helpers/extensions/context_extension.dart';
import 'package:quilt_flow_app/app/router/router_manager.dart';

class QuiltSnackBarManager {
  BuildContext? get context => GetIt.I<RouterManager>()
      .goRouter
      .routerDelegate
      .navigatorKey
      .currentContext;

  Future<void> showSuccess(String message) async {
    context?.showSuccessSnackBar(message);
  }

  Future<void> showError(String message) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context?.showErrorSnackBar(message);
    });
  }

  Future<void> showFavoriteSnackBar(
    String collectionName,
    bool isFavorite,
    VoidCallback? onTap,
  ) async {
    context?.showFavoriteSnackBar(collectionName, isFavorite, onTap);
  }

  void showLoading() {
    context?.loaderOverlay.show();
  }

  void hideLoading() {
    context?.loaderOverlay.hide();
  }
}
