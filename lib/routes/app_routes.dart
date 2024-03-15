import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/camera_screen/camera_screen.dart';
import '../presentation/upload_screen/upload_screen.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String cameraScreen = '/camera_screen';

  static const String uploadScreen = '/upload_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    cameraScreen: (context) => CameraScreen(),
    uploadScreen: (context) => UploadScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => UploadScreen()
  };
}
