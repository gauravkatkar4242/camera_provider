import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionProvider with ChangeNotifier {
  PermissionStatus? cameraPermission;
  PermissionStatus?  micPermission;
  CameraPermissionProvider(this.cameraPermission, this.micPermission) {
    // getPermissionStatus();
  }

  void getPermissionStatus() async {
    cameraPermission = await Permission.camera.status;
    micPermission = await Permission.microphone.status;
    print("Camera permission - $cameraPermission");
    print("mic permission - $micPermission");
    notifyListeners();
  }
}
