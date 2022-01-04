import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField1 extends StatelessWidget {
  CustomTextField1({Key? key, this.controller, this.hintText = ""})
      : super(key: key);

  // Data
  String hintText;

  // Controller
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Container(
        color: const Color.fromARGB(255, 168, 157, 143),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
              border: InputBorder.none,
              fillColor: Colors.white,
            ),
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField2 extends StatelessWidget {
  CustomTextField2({Key? key, this.controller, this.hintText = ""})
      : super(key: key);

  // Data
  String hintText;

  // Controller
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Container(
        color: const Color.fromARGB(255, 168, 157, 143),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
              border: InputBorder.none,
              fillColor: Colors.white,
            ),
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
