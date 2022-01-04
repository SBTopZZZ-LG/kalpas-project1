import 'package:flutter/material.dart';

// Pages
import './pages/loading.dart';
import './pages/sign_in.dart';
import './pages/sign_up.dart';

void main() {
  runApp(
    MaterialApp(
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
