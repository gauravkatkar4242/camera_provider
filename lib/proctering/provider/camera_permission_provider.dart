import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionProvider with ChangeNotifier {
  var cameraPermission;
  var micPermission;

  CameraPermissionProvider() {
    // getPermissionStatus();
  }

  void getPermissionStatus() async {
    cameraPermission = await Permission.camera.status;
    micPermission = await Permission.microphone.status;
    print(cameraPermission);
    print(micPermission);
    notifyListeners();
  }

  Future<void> requestPermission() async {
    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      await [Permission.camera, Permission.microphone].request();
    }
    getPermissionStatus();
  }

  void disAblePermissions() {
    cameraPermission = Permission.camera.isDenied;
    micPermission = Permission.microphone.isDenied;
    print("Disabled");
    getPermissionStatus();
  }
}
