import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  
  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = 
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  
  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
  
  // Initialize connectivity checking
  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      return;
    }
    _updateConnectionStatus(result);
  }
  
  // Update connection status based on connectivity result
  void _updateConnectionStatus(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
  }
  
  // Check current connectivity
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
