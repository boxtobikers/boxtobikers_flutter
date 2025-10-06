import 'package:flutter/material.dart';

class RidingPages extends StatefulWidget {
  const RidingPages({super.key});

  @override
  State<StatefulWidget> createState() => _RidingPagesState();
}

class _RidingPagesState extends State<RidingPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riding Page'),
      ),
      body: const Center(
        child: Text('This is the Riding Page'),
      ),
    );
  }
}