import 'package:camera/camera.dart';
import 'package:camera_provider/proctering/provider/camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraFeed extends StatefulWidget {
  const CameraFeed({Key? key}) : super(key: key);

  @override
  State<CameraFeed> createState() => _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => CameraProvider()),
    ],
    child:const CameraScreen()
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {

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
    print("$state ********************** from camera feed");
    if (state == AppLifecycleState.inactive) {
      print("State inactive");
      context.read<CameraProvider>().disposeCamera();
    }
    else if (state == AppLifecycleState.resumed) {
      print("State resumed");
      context.read<CameraProvider>().initCamera();
    }
  }
  @override
  Widget build(BuildContext context) {
    if (context.watch<CameraProvider>().controller == null || !context.watch<CameraProvider>().controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(context.watch<CameraProvider>().controller!);
  }
}

