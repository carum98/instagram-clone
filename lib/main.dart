import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/routers/router_gerenator.dart';
import 'package:instagram_clone/routers/router_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final navigator = GlobalKey<NavigatorState>();

  WidgetsBinding.instance!.addPostFrameCallback((_) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
          navigator.currentContext!,
          FEED,
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          navigator.currentContext!,
          LOGIN,
          (Route<dynamic> route) => false,
        );
      }
    });
  });

  runApp(MyApp(navigator: navigator));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;
  const MyApp({Key? key, required this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigator,
      initialRoute: LOADING,
      onGenerateRoute: RouterGenerator.generateRoute,
    );
  }
}
