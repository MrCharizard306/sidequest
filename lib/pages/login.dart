

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/components/my_button.dart';
import 'package:sidequest/components/my_textfield.dart';

class LoginPage extends StatefulWidget{
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();


  void wrongEmailmessage() {
      showDialog(context: context,
       builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email'),
        );
       },
      );
    }
  void wrongPasswordMessage() {
      showDialog(context: context,
       builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Password'),
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
      if(e.code == 'user-not-found'){
        wrongEmailmessage();

      } 
      else if (e.code == 'wrong-password'){
        
        wrongPasswordMessage();
      }
    } 
  } 
    
 // sin in user in
  void signUp(){}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 200,),

            Text(
              'Welcome back you\'ve been missed!',
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
          MyButton(
            onTap: signUserIn,
          ),
          const SizedBox(height: 50),

          // sign up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Not a member?'),
              SizedBox(width: 4),

              Text(
                'Register now',
                style: TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold
                  ),
                ),
              ],
            )
          ],
        ),
      ),      
    ),
  );


  }
}
