import 'package:flutter/material.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:instagram_clone/pages/loading_page.dart';
import 'package:instagram_clone/routers/router_names.dart';

import '../pages/create_post_page.dart';
import '../pages/main_page.dart';
import '../pages/login_page.dart';
import '../pages/profile_page.dart';
import '../pages/register_page.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case LOADING:
        return MaterialPageRoute(builder: (_) => const LoadingPage());
      case LOGIN:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case REGISTER:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case MAIN:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case CREATE_POST:
        return MaterialPageRoute(builder: (_) => const CreatePostPage());
      case PROFILE:
        final user = args as UserModel;
        return MaterialPageRoute(builder: (_) => ProfilePage(user: user));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Text('No route defined for ${settings.name}'),
          ),
        );
    }
  }
}
