import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home_screen.dart';
import 'registration_screen.dart';
import 'user.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 15),
            Text(
              'Silahkan Login Untuk Memulai Aplikasi',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final username = usernameController.text;
                final password = passwordController.text;

                final box = Hive.box<User>('users');
                User? user = box.values.firstWhere(
                  (user) =>
                      user.username == username && user.password == password,
                  orElse: () => User(
                      username: '', password: ''), // Kembalikan user default
                );

                if (user.username.isNotEmpty) {
                  // Jika pengguna ditemukan
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(username: username)),
                  );
                } else {
                  // Jika pengguna tidak ditemukan
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid credentials')));
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()));
              },
              child: Text('Belum punya akun? Registrasi'),
            ),
          ],
        ),
      ),
    );
  }
}
