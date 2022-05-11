import 'package:camera_provider/camera_test_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sample1 extends StatefulWidget {
  const Sample1({Key? key}) : super(key: key);

  @override
  State<Sample1> createState() => _Sample1State();
}

class _Sample1State extends State<Sample1> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    print("Dispose called Page 1");
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("$state ********************** from sample 1");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Hello"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 150,
              child: Center(child: Text("Bla Bla Bla")),),
            SizedBox(
              height: 50,
              child: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "Overall instruction"),
                    Tab(text: "Section instruction"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CameraTestPage()));
                        },
                        child: const Text("Next page"),
                      ),
                    ],
                  ),
                  const Center(child:  Text("Bla Bla Bla")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
