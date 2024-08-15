import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'location_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        backgroundColor: Colors.blue,
        body:  Center(
          child: GestureDetector(
            onTap: (){
              print("hello");
            },
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
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
    );
  }
}

