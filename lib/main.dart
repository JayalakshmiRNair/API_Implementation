import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rest_api_implementation/screens/gallery_page.dart';

import 'model_class/Data.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('shutterBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImagePreview(),


    );
  }
}
