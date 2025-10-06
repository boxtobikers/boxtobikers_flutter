import 'package:flutter/material.dart';

class SettingsPages extends StatefulWidget {
  const SettingsPages({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPagesState();
}

class _SettingsPagesState extends State<SettingsPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: const Center(
        child: Text('This is the Settings Page'),
      ),
    );
  }
}