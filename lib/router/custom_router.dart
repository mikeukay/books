import 'package:books/router/routes.dart';
import 'package:books/screens/book_screen.dart';
import 'package:books/screens/home_screen.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    RoutingData data = settings.name.getRoutingData;
    switch(data.route) {
      case HOME_ROUTE:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeScreen(),
          settings: settings,
        );
      case BOOK_ROUTE:
        if(!data.hasParam(BOOK_ID_PARAM))
          return MaterialPageRoute(builder: (ctx) => HomeScreen());
        return MaterialPageRoute(
          builder: (ctx) => BookScreen(bookId: data[BOOK_ID_PARAM]),
          settings: settings,
        );
      default:
        return MaterialPageRoute(builder: (ctx) => HomeScreen());
    }
  }
}

/* https://www.filledstacks.com/post/flutter-web-advanced-navigation/ */
class RoutingData {
  final String route;
  final Map<String, String> _queryParameters;

  RoutingData({
    this.route,
    Map<String, String> queryParameters,
  }) : _queryParameters = queryParameters;

  operator [](String key) => _queryParameters[key];

  bool hasParam(String key) => _queryParameters.containsKey(key);
}

extension StringExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    // print('queryParameters: ${uriData.queryParameters} path: ${uriData.path}');
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}