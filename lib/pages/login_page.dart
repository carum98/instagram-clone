import 'package:flutter/material.dart';
import 'package:instagram_clone/core/auth.dart';
import 'package:instagram_clone/routers/router_names.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String email, password;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) => email = value,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              onChanged: (value) => password = value,
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                Auth().login(
                  email: email,
                  password: password,
                );
              },
            ),
            TextButton(
              child: const Text('Register'),
              onPressed: () {
                Navigator.pushNamed(context, REGISTER);
              },
            )
          ],
        ),
      ),
    );
  }
}
