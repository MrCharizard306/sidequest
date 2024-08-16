

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/components/my_button.dart';
import 'package:sidequest/components/my_textfield.dart';

class RegisterPage extends StatefulWidget{
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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


  void signUserUp() async{
    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
      
      },
    );
    try {
      if (passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
        );
         Navigator.pop(context);
      }
      else{

        Navigator.pop(context);
        showErrorMessage("Passwords do not match");
      }
      /// pop loading circle
      
    } on FirebaseAuthException catch (e){
      // pop loading circle
      Navigator.pop(context);
      showErrorMessage(e.code);
    } 
  } 
    

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50,),
            
              Text(
                'Lets get the adverture started!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize:  16,
                ),
              ),
              const SizedBox(height: 25),
            
            MyTextField(controller: emailController, hintText: 'Email', obsureText: false),
            const SizedBox(height: 10,),
            
            MyTextField(controller: passwordController, hintText: 'Password', obsureText: true),
            const SizedBox(height: 10,),
            // confirm password
            MyTextField(controller: confirmPasswordController, hintText: 'Confirm Password', obsureText: true),
            const SizedBox(height: 10,),
            
            MyButton(
              text: 'Sign up',
              onTap: signUserUp,
            ),
            const SizedBox(height: 50),
            
            // sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text('Already have an account?'),

                 SizedBox(width: 4),
                 GestureDetector.new(
                  onTap: widget.onTap,
                  child:  Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold
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
