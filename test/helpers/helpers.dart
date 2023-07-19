import 'package:flutter/material.dart';

class HelperWidget extends StatelessWidget {
  final Widget child;
  const HelperWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: child));
  }
}
