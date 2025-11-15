import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Screen/movie.dart';
import 'Screen/detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MovieDisplay()),
        GetPage(name: '/detail', page: () => const DetailScreen()),
      ],
    );
  }
}
