import 'package:flutter/material.dart';


/// Placeholder screen for new tabs...will delete soon
class ScreenOne extends StatefulWidget {
  const ScreenOne({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'APP',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 100),
        ),
      ],
    );
  }
}
