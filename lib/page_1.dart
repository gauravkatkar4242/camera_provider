import 'package:camera_provider/black_page.dart';
import 'package:camera_provider/camera_test_page.dart';
import 'package:camera_provider/proctering/camera_feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Page1 extends StatefulWidget{
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("$state ********************** from page 1");
    if (state == AppLifecycleState.inactive) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BlackPage()), (Route<dynamic> route) => false);
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Aptitude assessment"),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Icon(
                    Icons.info_outline,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Icon(
                    Icons.question_mark_rounded,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 30,
                  ),
                ),
              ],
            ),
            Container(
              height: 54,
              width: 54,
              color: Colors.red,
              child: const CameraFeed(),
            ),
          ],
          toolbarHeight: 56,
        ),
        body: const Center(
          child: Text("Page 1"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Page1()));
          },
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
