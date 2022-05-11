import 'package:camera/camera.dart';
import 'package:camera_provider/proctering/provider/camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraFeed extends StatelessWidget {
  const CameraFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CameraProvider()),
    ], child: const CameraScreen());
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      context.read<CameraProvider>().disposeCamera();
      print("From Camera_feed - State inactive camera Disposed");
      Navigator.of(context).pop();
    } else if (state == AppLifecycleState.resumed) {
      context.read<CameraProvider>().initCamera();
      print("From Camera_feed - State resumed Camera initialized");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(builder: (context, cameraProvider, child) {
      if (cameraProvider.controller == null ||
          !cameraProvider.controller!.value.isInitialized) {
        return const Center(child: CircularProgressIndicator());
      }
      return CameraPreview(cameraProvider.controller!);
    });
  }
}
