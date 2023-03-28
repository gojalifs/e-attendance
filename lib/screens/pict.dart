import 'package:flutter/material.dart';

class TakePicturepage extends StatefulWidget {
  const TakePicturepage({super.key});

  @override
  State<TakePicturepage> createState() => _TakePicturepageState();
}

class _TakePicturepageState extends State<TakePicturepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Picture'),
      ),
    );
  }
}
