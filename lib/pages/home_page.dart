import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // change
import 'package:sidequest/main.dart';

void main() {
  runApp(const MyApp());
}
void signoutUser(){
  FirebaseAuth.instance.signOut();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xEB92D4F0),
        appBar: AppBar(
          title: const Text("SideQuests"),
          backgroundColor: const Color(0xEB92D4F0),
          elevation: 0,
        ),
        drawer: Drawer(
          child: Column(children: [
              const SizedBox(height: 50),
            // profile page
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Profile", style: TextStyle( fontFamily: 'Itim')),
              onTap: () {
                
                Navigator.pushNamed(context, '/profilepage');
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Quests", style: TextStyle( fontFamily: 'Itim')),
              onTap: () { 
                Navigator.pushNamed(context, '/questpage');
              }
            ),
            // settings 
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings", style: TextStyle( fontFamily: 'Itim')),
              onTap: () {
                
                Navigator.pushNamed(context, '/settingspage');
              }
            ),
          
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                
                signoutUser();
                }
            ),
          ],)
        )
      )
    );
  }
}