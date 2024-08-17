import 'package:flutter/material.dart';
import '../main.dart';

void main() {
  runApp(const MyApp());
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: Color.fromARGB(235, 255, 255, 255),
      appBar: AppBar(
        title: const  Text("Profile"),
        backgroundColor:const Color(0xEB92D4F0),
      )
    );
  }
}