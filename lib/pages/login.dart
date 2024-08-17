

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/components/my_button.dart';
import 'package:sidequest/components/my_textfield.dart';

class LoginPage extends StatefulWidget{
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // errormessage
  void showErrorMessage(String message) {
      showDialog(
       context: context,
       builder: (context) {
        return  AlertDialog(
          backgroundColor: Colors.grey,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          )
          
        );
       },
      );
    }


  void signUserIn() async{
    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
      
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
      );
      /// pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      // pop loading circle
      Navigator.pop(context);
      showErrorMessage(e.code);
    } 
  } 
    
 // sin in user in
  void signUp(){}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xEB92D4F0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50,),
            
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize:  20,
                  fontFamily: 'Itim'
                ),
              ),
              const SizedBox(height: 25),
            
            MyTextField(controller: emailController, hintText: 'Email', obsureText: false),
            const SizedBox(height: 10,),
            
            MyTextField(controller: passwordController, hintText: 'Password', obsureText: true),
            const SizedBox(height: 10,),
            MyButton(
              text: "Log in",
              onTap: signUserIn,
            ),
            const SizedBox(height: 50),

            
            // sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [  
                
                Text('Not a member?',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Itim' 
                ),
                
                ),
                

                SizedBox(width: 4),
                GestureDetector.new(
                  onTap: widget.onTap,
                  child:  Text(
                    'Register now',
                    style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Itim'
                      ),
                    ),
                ),
                ],
              )
            ],
                    ),
          ),
      ),      
    ),
  );


  }
}
