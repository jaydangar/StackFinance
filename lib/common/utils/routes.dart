import 'package:StackFinance/explore/screen/explore.dart';
import 'package:StackFinance/home/screen/home.dart';
import 'package:StackFinance/login/login.dart';
import 'package:flutter/material.dart';

// *  This class provides the functionality to handle route between pages
class Routing {
  static const HomePageRoute = '/home';
  static const LogInPageRoute = '/login';
  static const ExplorePageRoute = '/explore';

  static Route<dynamic> generateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case HomePageRoute:
        final _user = routeSettings.arguments;
        return MaterialPageRoute(
          builder: (context) => HomePage(
            _user
          ),
        );
      case LogInPageRoute:
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case ExplorePageRoute:
        final _user = routeSettings.arguments;
        return MaterialPageRoute(
          builder: (context) => ExplorePage(
            _user
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
    }
  }
}
