import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/post_provider.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/routers/router_gerenator.dart';
import 'package:instagram_clone/routers/router_names.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB8B7tt8gEhz8KLJVXke9gyD4wZ7hBS7JI",
        authDomain: "instagram-clone-20a00.firebaseapp.com",
        projectId: "instagram-clone-20a00",
        storageBucket: "instagram-clone-20a00.appspot.com",
        messagingSenderId: "1032309295781",
        appId: "1:1032309295781:web:34861bd830d98b9cb55b4c",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  await Firebase.initializeApp();

  final navigator = GlobalKey<NavigatorState>();

  WidgetsBinding.instance!.addPostFrameCallback((_) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
          navigator.currentContext!,
          MAIN,
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
    return MultiProvider(
      providers: [
        Provider<UserProvider>(create: (_) => UserProvider()),
        Provider<PostProvider>(create: (_) => PostProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            color: Colors.black,
            elevation: 0,
          ),
          scaffoldBackgroundColor: Colors.black,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 0,
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        navigatorKey: navigator,
        initialRoute: LOADING,
        onGenerateRoute: RouterGenerator.generateRoute,
      ),
    );
  }
}
