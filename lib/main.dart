import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'app/app_binding.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, 
      systemNavigationBarColor: Colors.black,
    ),
  );
  
  // Initialize storage
  final storageService = StorageService();
  await storageService.init();
  
  // Register global dependencies
  Get.put<StorageService>(storageService, permanent: true);
  
  // Initialize app with bindings
  runApp(
    const App(),
  );

  AppBinding().dependencies();
}
