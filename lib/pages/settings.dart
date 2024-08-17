import 'package:flutter/material.dart';
import '../main.dart';

void main() {
  runApp(const MyApp());
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: Color.fromARGB(235, 255, 255, 255),
      appBar: AppBar(
        title: const  Text("Settings"),
        backgroundColor:Color.fromARGB(235, 255, 255, 255),
      )
    );
  }
}