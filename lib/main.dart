import 'package:books/router/custom_router.dart';
import 'package:books/router/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color hooloovoo = Color(0xFF42DAFA);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snap) => snap.connectionState == ConnectionState.done ? MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: hooloovoo,
          accentColor: hooloovoo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: CustomRouter.generateRoute,
        initialRoute: HOME_ROUTE,
      ) : Container(
        color: Colors.white,
      ),
    );
  }
}