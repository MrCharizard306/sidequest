import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sidequest/login.dart';
import 'firebase_options.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< Updated upstream
      home: Scaffold(
        
        backgroundColor: Colors.deepPurple,
        body:  Center(
          child: GestureDetector(
            onTap: (){
              print("hello");
            },
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 160, 35, 100),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(125),
              child: Text(
                "SIDEQUEST",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            
            
            ),
          ),
        ),
      ),
=======
      home: LoginPage(),
>>>>>>> Stashed changes
    );
  }
}

