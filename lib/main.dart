import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/maintenance_screen.dart';
import 'services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whiski Maintain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaintenanceApp(),
      routes: {
        '/login': (context) => LoginScreen(onSignIn: () {
          Navigator.pushReplacementNamed(context, '/maintenance');
        }),
        '/register': (context) => RegisterScreen(onSignIn: () {
          Navigator.pushReplacementNamed(context, '/maintenance');
        }),
        '/maintenance': (context) => MaintenanceScreen(onSignOut: () {
          AuthService.instance.signOut();
        }),
      },
    );
  }
}

class MaintenanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.currentUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaintenanceScreen(onSignOut: () {
            AuthService.instance.signOut();
          });
        } else {
          return LoginScreen(onSignIn: () {
            Navigator.pushReplacementNamed(context, '/maintenance');
          });
        }
      },
    );
  }
}