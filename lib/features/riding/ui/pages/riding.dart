import 'package:flutter/material.dart';

class RidingPage extends StatefulWidget {
  const RidingPage({super.key});

  @override
  State<StatefulWidget> createState() => _RidingPageState();
}

class _RidingPageState extends State<RidingPage> {
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