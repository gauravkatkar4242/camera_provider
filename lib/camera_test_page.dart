import 'package:camera_provider/proctering/camera_feed.dart';
import 'package:camera_provider/proctering/provider/camera_permission_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CameraTestPage extends StatefulWidget {
  const CameraTestPage({Key? key}) : super(key: key);

  @override
  State<CameraTestPage> createState() => _CameraTestPageState();
}

class _CameraTestPageState extends State<CameraTestPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    print("InitState Called ****************** ");
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // context.read<CameraPermissionProvider>().getPermissionStatus();
    print("didChangeDependencies Called ****************** ");

    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("getPermissions from resume********");
      context.read<CameraPermissionProvider>().getPermissionStatus();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Camera Test screen"),
        ),
        body: Center(child: permissionView())
        // Text("Hello")
        );
  }

  Widget permissionView() {
    var cameraPermission =
        context.watch<CameraPermissionProvider>().cameraPermission;
    var micPermission = context.watch<CameraPermissionProvider>().micPermission;

    if (cameraPermission == null ||
        micPermission == null ){
      context.read<CameraPermissionProvider>().requestPermission();
      return const Text("Requesting Permission");
    }
    else if (cameraPermission == PermissionStatus.granted &&
        micPermission == PermissionStatus.granted) {
      return Column(
        children: [
          const Expanded(child: CameraFeed()),
          ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => const Page1()));
                context.read<CameraPermissionProvider>().disAblePermissions();
              },
              child: const Text("All Good, Go next"))
        ],
      );
    }
    else if (
        cameraPermission == PermissionStatus.denied ||
        micPermission == PermissionStatus.denied) {
      // context.read<CameraPermissionProvider>().requestPermission();
      return Column(
        children: [
          Text("Permission Denied"),
          ElevatedButton(
              onPressed: () {
                openAppSettings();
                // context.read<CameraPermissionProvider>().requestPermission();
              },
              child: const Text("Open Settings")),
        ],
      );
    }
    else if (cameraPermission == PermissionStatus.permanentlyDenied ||
        micPermission == PermissionStatus.permanentlyDenied) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Please allow camera permissions"),
          ElevatedButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text("Open Settings"))
        ],
      );
    } else {
      return Center(
          child: Text(
              '${cameraPermission} Please allow Camera and Microphone permissions through settings'));
    }
  }
}
