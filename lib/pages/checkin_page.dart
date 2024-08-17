import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckInPage(),
    );
  }
}

class CheckInPage extends StatefulWidget {
  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _checkInCount = 0;

  @override
  void initState() {
    super.initState();
    _getCheckInCount();
  }

  Future<void> _getCheckInCount() async {
    DocumentSnapshot snapshot = await _firestore.collection('stats').doc('check_ins').get();
    setState(() {
      _checkInCount = snapshot.exists ? snapshot.get('count') : 0;
    });
  }

  Future<void> _incrementCheckIn() async {
    await _firestore.collection('stats').doc('check_ins').set({
      'count': FieldValue.increment(1)
    }, SetOptions(merge: true));
    _getCheckInCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Check-In Feature')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Check-in Count: $_checkInCount'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCheckIn,
              child: Text('Check In'),
            ),
          ],
        ),
      ),
    );
  }
}