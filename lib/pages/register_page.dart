import 'package:flutter/material.dart';
import 'package:instagram_clone/core/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String name, email, password;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (value) => name = value,
            ),
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
              child: const Text('Register'),
              onPressed: () {
                Auth().register(
                  name: name,
                  email: email,
                  password: password,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
