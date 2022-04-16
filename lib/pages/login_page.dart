import 'package:flutter/material.dart';
import 'package:instagram_clone/core/auth.dart';
import 'package:instagram_clone/routers/router_names.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String email, password;

    const gap = SizedBox(height: 30);

    final decoration = InputDecoration(
      filled: true,
      isDense: true,
      hintStyle: const TextStyle(fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Spacer(),
            const Image(
              image: AssetImage('assets/logo.png'),
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    decoration: decoration.copyWith(
                      hintText: 'Phone number, username or email',
                    ),
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: decoration.copyWith(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    onChanged: (value) => password = value,
                  ),
                  gap,
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue),
                  ),
                  gap,
                  ElevatedButton(
                    child: const Text('Log in'),
                    onPressed: () => Auth().login(email: email, password: password),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.maxFinite),
                      primary: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
            gap,
            const Divider(thickness: 3),
            gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  child: const Text('Sign up'),
                  onPressed: () => Navigator.pushNamed(context, REGISTER),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
