// Dart imports
import 'dart:ui';

// Package imports
import 'package:flutter/material.dart';

// Pages
import './loading.dart';
import './sign_up.dart';
import './dashboard.dart';

// Scripts
import '../scripts/auth_framework.dart';
import '../scripts/fas.dart';

// Widgets
import '../widgets/custom_tf.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers
  TextEditingController email = TextEditingController(),
      password = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    SecureStore.read("user/email").then((email) {
      if (email != null) {
        SecureStore.read("user/password").then((password) {
          if (password != null) {
            SecureStore.read("user/time").then((time) {
              if (time != null) {
                // Check difference (7200 seconds = 120 minutes = 2 hours)
                int timeInt = int.parse(time);

                if (DateTime.now().millisecondsSinceEpoch - timeInt <
                    7200 * 1000) {
                  // Validate credentials with api
                  setState(() {
                    _isLoading = true;
                  });

                  Auth.logIn(email, password).then((result) {
                    if (result.statusCode == 200) {
                      // Sign in success

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const DashboardPage()));

                      // Update time
                      SecureStore.write("user/time",
                          DateTime.now().millisecondsSinceEpoch.toString());
                    }

                    setState(() {
                      _isLoading = false;
                    });
                  });
                } else {
                  // Clear credentials, expired
                  SecureStore.delete("user/email");
                  SecureStore.delete("user/password");
                  SecureStore.delete("user/time");

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Previous log in expired")));
                }
              }
            });
          }
        });
      }
    });
  }

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
                              "Sign in",
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
                            const SizedBox(height: 15),
                            CustomTextField2(
                              hintText: "Password:",
                              controller: password,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: const Text(
                                    "Forgot password?",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onTap: () {},
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
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
                                  return;
                                }

                                String password = this.password.text;

                                if (password.length < 5) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Password must be greater than 4 characters")));
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                // Perform api
                                Auth.logIn(email, password).then((value) {
                                  if (value.statusCode == 404) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Account with email address not found")));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please sign up before logging in")));

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    return;
                                  }

                                  if (value.statusCode == 403) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Incorrect password")));

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

                                  // Save login information
                                  SecureStore.write("user/email", email);
                                  SecureStore.write("user/password", password);
                                  SecureStore.write(
                                      "user/time",
                                      DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString());

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => const DashboardPage()));

                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 42,
                                ),
                                child: Text(
                                  "Sign in",
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
                                  "Or Sign In With",
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
                                  "Don't have an account? ",
                                  style: TextStyle(fontSize: 16),
                                ),
                                InkWell(
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.yellow.shade800,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => const SignUpPage()));
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
