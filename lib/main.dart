import 'package:flutter/material.dart';

// Pages
import './pages/sign_in.dart';

// Scripts
import './scripts/fas.dart';

void main() {
  SecureStore.initialize();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
