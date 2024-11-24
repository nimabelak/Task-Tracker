import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetracker/Home.dart';
import 'package:timetracker/TimeTracker.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('TaskTracker');
    setWindowMinSize(const Size(550, 600));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Tracker',
      home: Home(),
    );
  }
}
