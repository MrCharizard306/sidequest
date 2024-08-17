import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obsureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsureText,

  });
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: controller,
                obscureText: obsureText,

                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 20),  
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: Colors.black
                  )
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: hintText,

              ),
              
            ),

          );
  }



}          