
import 'package:flutter/material.dart';

import 'camera_test_page.dart';

class BlackPage extends StatefulWidget{
  const BlackPage({Key? key}) : super(key: key);

  @override
  State<BlackPage> createState() => _BlackPageState();
}

class _BlackPageState extends State<BlackPage>  with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("$state ********************** from blank page");
     if (state == AppLifecycleState.resumed) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CameraTestPage()));
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Black Page"),),
    );
  }
}
