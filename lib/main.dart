import 'package:flutter/material.dart';
import 'package:newweather/newpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Newpage(),
      theme:
          ThemeData(colorScheme: ColorScheme.dark(), fontFamily: "Quicksand"),
    );
  }
}
