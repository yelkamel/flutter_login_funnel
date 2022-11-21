import 'package:flutter/material.dart';
import 'package:flutter_login_funnel/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  bool signInWithEmailAndPassword(String email, String password) {
    return true;
  }

  bool registerWithEmailAndPassword(
      String name, String email, String password) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LoginFunnel(
      loadingWidget: const CircularProgressIndicator(),
      backWidget: const Icon(Icons.arrow_back),
      onEmailValidation: (_) => _.contains('@'),
      onPasswordValidation: (_) => _.length > 3,
      onNameValidation: (_) => _.length > 3,
      onAuthSubmit: (_) async {
        if (!_.createAccount) {
          final res = signInWithEmailAndPassword(_.email, _.password);
          if (!res) return false;
        }
        final res = registerWithEmailAndPassword(_.name, _.email, _.password);
        if (!res) return false;
        return true;
      },
    );
  }
}
