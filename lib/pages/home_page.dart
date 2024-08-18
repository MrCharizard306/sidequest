import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // change
import 'package:sidequest/main.dart';
import 'package:sidequest/pages/progress_page.dart';
import 'package:sidequest/pages/quest.dart';
import 'package:sidequest/pages/settings.dart';

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
        backgroundColor: Color.fromARGB(235, 255, 255, 255),
        appBar: AppBar(
          title: const Text("SideQuests", style: TextStyle(fontSize: 30.0, fontFamily: 'Itim')),
          backgroundColor: Color.fromARGB(235, 255, 255, 255),
          elevation: 0,
        ),
        body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: ExpansionTile(
          title: const Text(
            'Current Quest', textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Itim', fontSize: 24)),
          leading: const Icon(Icons.task),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Go outside and touch grass!!',
                style: TextStyle(fontSize: 16, fontFamily: 'Itim'),
              ),
            ),
          ],
        ),
        ),
        drawer: Drawer(
          child: Column(children: [
              const SizedBox(height: 50),
            // profile page
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text("Progress", style: TextStyle( fontFamily: 'Itim')),
              onTap: () {
                
                Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScoreCalculator()),
          );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Quests", style: TextStyle( fontFamily: 'Itim')),
              onTap: () { 
                Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuestsPage()),
          );
              }
            ),
            // settings 
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings", style: TextStyle( fontFamily: 'Itim')),
              onTap: () {
                
                Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
          );
              }
            ),
          
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout", style: TextStyle(fontFamily: 'Itim')),
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