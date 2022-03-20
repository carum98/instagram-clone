import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/loading_page.dart';
import 'package:instagram_clone/routers/router_names.dart';

import '../pages/main_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case LOADING:
        return MaterialPageRoute(builder: (_) => const LoadingPage());
      case LOGIN:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case REGISTER:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case MAIN:
        return MaterialPageRoute(builder: (_) => const MainPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Text('No route defined for ${settings.name}'),
          ),
        );
    }
  }
}
