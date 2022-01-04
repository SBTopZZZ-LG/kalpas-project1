// Dart imports
import 'dart:ui';

// Package imports
import 'package:flutter/material.dart';

// Pages
import './loading.dart';

// Scripts
import '../scripts/auth_framework.dart';

// Widgets
import '../widgets/custom_tf.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers
  TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      passwordConf = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingPage());
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/backdrop.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
              ),
            ),
          ),
          Positioned(
            left: -4,
            right: -4,
            bottom: -7,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 40,
                    ),
                    child: Text(
                      "Welcome!!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(35),
                        child: Column(
                          children: [
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 14, 100),
                              ),
                            ),
                            const SizedBox(height: 30),
                            CustomTextField1(
                              hintText: "Email:",
                              controller: email,
                            ),
                            const SizedBox(height: 8),
                            CustomTextField2(
                              hintText: "Password:",
                              controller: password,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField2(
                                hintText: "Re-enter Password:",
                                controller: passwordConf),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                // Validate inputs
                                RegExp emailRE =
                                    RegExp(r'^[a-z0-9\.]+@[a-z0-9\.]+$');
                                String email = this.email.text;

                                if (!emailRE.hasMatch(email)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please enter a valid email address")));

                                  setState(() {
                                    _isLoading = false;
                                  });

                                  return;
                                }

                                String password = this.password.text;

                                if (password.length < 5) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Password must be greater than 4 characters")));

                                  setState(() {
                                    _isLoading = false;
                                  });

                                  return;
                                }

                                String passwordConf = this.passwordConf.text;

                                if (password != passwordConf) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Password confirmation failure")));

                                  setState(() {
                                    _isLoading = false;
                                  });

                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                // Perform api
                                Auth.register(email, password, passwordConf)
                                    .then((value) {
                                  if (value.statusCode == 400) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Password confirmation failure")));

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    return;
                                  }

                                  if (value.statusCode == 403) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Sorry, this email is already in use")));

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    return;
                                  }

                                  if (value.statusCode != 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Unknown error occurred")));

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    return;
                                  }

                                  Navigator.of(context).pop();
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 42,
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.resolveWith(
                                  (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      const Color.fromARGB(255, 116, 197, 244),
                                ),
                                shadowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                              ),
                            ),
                            const SizedBox(height: 33),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    height: 4,
                                    indent: 6,
                                    endIndent: 6,
                                    thickness: 2,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Or Sign Up With",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Divider(
                                    height: 4,
                                    indent: 6,
                                    endIndent: 6,
                                    thickness: 2,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 17),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircleAvatar(
                                  radius: 21,
                                  foregroundImage:
                                      AssetImage("images/google.png"),
                                  backgroundColor: Colors.transparent,
                                ),
                                SizedBox(width: 32),
                                CircleAvatar(
                                  radius: 21,
                                  foregroundImage:
                                      AssetImage("images/facebook.png"),
                                  backgroundColor: Colors.transparent,
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Have an account? ",
                                  style: TextStyle(fontSize: 16),
                                ),
                                InkWell(
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.yellow.shade800,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
