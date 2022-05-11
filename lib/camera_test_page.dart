import 'dart:ui';

import 'package:camera_provider/page_1.dart';
import 'package:camera_provider/proctering/camera_feed.dart';
import 'package:camera_provider/proctering/provider/camera_permission_provider.dart';
import 'package:flutter/foundation.dart';
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

  final double cameraFeedSize = 328;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
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
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    //title
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Proctoring Instructions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //camera feed
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: cameraFeedSize,
                        width: cameraFeedSize,
                        child: kIsWeb
                            ? Container(
                                color: Colors.red,
                              )
                            : Center(
                                child: Consumer<CameraPermissionProvider>(
                                    builder: (context, cameraPermissions, child) =>
                                        cameraView(cameraPermissions)),
                              ),
                      ),
                    ),
                    // Instructions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        instructionPoints(
                          "• Please align yourself so as to fit in the frame provided in the camera preview and please ensure that you are always present in the camera frame. If you are using dual camera laptops/iPad, please ensure that the front camera is selected",
                        ),
                        instructionPoints(
                          "• Images from the webcam feed and your tab switch count will be monitored and will be displayed in your report ",
                        ),
                        instructionPoints(
                          "• Please ensure that you adhere to the assessment guidelines. Failure to comply with the assessment guidelines will impact negatively on your scores up to disqualification",
                        )
                      ],
                    ),
                    //continue button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                // ****** TO BE ADDED - disabled if Permissions are Denied*******
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Page1()));
                              },
                              child: const Text("Continue")),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // for Background blur and permission denied message
              Positioned.fill(child: Align(
                  child: Consumer<CameraPermissionProvider>(
                    builder: (context, permissions, child) {
                      if (permissions.cameraPermission != PermissionStatus.granted ||
                          permissions.micPermission != PermissionStatus.granted) {
                        var disabledPermissions = "";
                        if (permissions.cameraPermission !=
                            PermissionStatus.granted) {
                          disabledPermissions = disabledPermissions + "Camera";
                        }
                        if (permissions.micPermission != PermissionStatus.granted) {
                          if (disabledPermissions.isNotEmpty) {
                            disabledPermissions = disabledPermissions + " & ";
                          }
                          disabledPermissions = disabledPermissions + "Microphone";
                        }
                        return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 70,vertical: 170),
                              color: Colors.black.withOpacity(0.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Your $disabledPermissions access is blocked!",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  const Text(
                                    "To grant permission, go to settings",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),

                                    child: const Text(
                                      "SETTINGS",
                                      style: TextStyle(
                                          color: Color(0xffff8308),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      openAppSettings();
                                    },
                                  ),
                                ],
                              ),
                            ));
                      }
                      return Container();
                    },
                  ),
                ),
              )
            ],
          ),
        )
        // Text("Hello")
        );
  }

  Widget cameraView(permissions) {
    print("Camera View Rebuilt ********");
    if (permissions.cameraPermission == null ||
        permissions.micPermission == null) {
      [Permission.camera, Permission.microphone].request().then((value) {
        context.read<CameraPermissionProvider>().getPermissionStatus();
      });
      return const Text("Requesting Permission");
    } else if (permissions.cameraPermission == PermissionStatus.granted &&
        permissions.micPermission == PermissionStatus.granted) {
      return Stack(
        fit: StackFit.expand,
        children: [
          const CameraFeed(),
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.srcOut,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ), // This one will handle background + difference out
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: cameraFeedSize - 30,
                    width: cameraFeedSize - 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(cameraFeedSize),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black87,
          ),
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(1),
              BlendMode.srcOut,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ), // This one will handle background + difference out
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: cameraFeedSize - 30,
                    width: cameraFeedSize - 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(cameraFeedSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  TextStyle instructionTextStyle() {
    return const TextStyle(
      height: 1.2,
      fontSize: 16,
      color: Color(0xFF666666),
    );
  }

  Widget instructionPoints(body) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        body,
        style: instructionTextStyle(),
        textAlign: TextAlign.left,
      ),
    );
  }
}
