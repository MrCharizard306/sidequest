import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sidequest/pages/auth_page.dart';
import 'package:sidequest/pages/home_page.dart';
import 'package:sidequest/pages/location_page.dart';
import 'package:sidequest/pages/login.dart';
import 'package:sidequest/pages/photo_page.dart';
import 'package:sidequest/pages/profile.dart';
import 'package:sidequest/pages/quest.dart';
import 'package:sidequest/pages/settings.dart';
import 'pages/firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      routes: {
        '/homepage': (context) => HomePage(),
        '/settingspage': (context) => SettingsPage(),
        '/profilepage': (context) => ProfilePage(),
        '/questpage': (context) => QuestsPage(),
        '/locationpage': (context) => LocationPage(),
        '/photopage': (context) => PhotoFeedScreen(),
      }
    );
  }
}

