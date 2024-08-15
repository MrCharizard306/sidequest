

import 'package:flutter/material.dart';
import 'package:sidequest/components/my_button.dart';
import 'package:sidequest/components/my_textfield.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(){} // sing user in
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50,),

            Text(
              'Welcome back you\'ve been missed',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize:  16,
              ),
            ),
            const SizedBox(height: 25),

          MyTextField(controller: usernameController, hintText: 'Username', obsureText: false),
          const SizedBox(height: 10,),
          MyTextField(controller: usernameController, hintText: 'Password', obsureText: true),
          const SizedBox(height: 10,),
          MyButton(
            onTap: signUserIn,
          )
              
          ])

        )



      )
        //Welcome Back
        // Username textfiedl

        //password text

        // sing in button
        //not a member? registar now
      
      
    );
  }
}
