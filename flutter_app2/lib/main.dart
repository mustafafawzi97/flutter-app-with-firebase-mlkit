import 'package:flutter_app2/mlkit/ml_home.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp2());

class MyApp2 extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D-learning app',
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
      ),

      // home: new WallScreen(analytics: analytics, observer: observer),
      home: new MLHome(),
    );
  }
}
