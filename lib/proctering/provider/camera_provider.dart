import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

class CameraProvider with ChangeNotifier  {
  CameraController? _controller;
  CameraController? get controller => _controller;

  CameraProvider(){
    initCamera();
  }
  Future<void> initCamera() async {
    try {
      var cameraList =
          await availableCameras(); // gets all available cameras from device
      if (_controller != null) {
        print("************************************************** disposed in initCam");
        await _controller!.dispose();
      }
      CameraDescription? cameraDescription;
      for (var camera in cameraList) {
        if (camera.lensDirection == CameraLensDirection.external ||
            camera.lensDirection == CameraLensDirection.front) {
          cameraDescription = camera;
          break;
        }
      }
      if (cameraDescription == null) {
        // exception handler to be added
        return;
      }
      final CameraController cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.medium,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      if (cameraController.value.hasError) {
        // exception handler to be added
      }
      await cameraController.initialize();
      print("Initialized................");
      print(cameraController.value.isInitialized);
      _controller = cameraController;
      notifyListeners();
    } on CameraException catch (e) {
      // exception handler to be added
    }
  }

  void disposeCamera(){
    _closeCamera();
  }

  Future<void> _closeCamera() async {
    if (_controller == null) {
      return;
    }
    await _controller!.dispose();
    print("Camera Disposed");
  }
}
