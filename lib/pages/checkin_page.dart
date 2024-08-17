import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _checkInCount = 0;
  bool _hasCheckedIn = false;
  late Stream<DocumentSnapshot> _checkInsStream;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _checkInsStream = _firestore.collection('stats').doc('check_ins').snapshots();
  }

  Future<void> _initializeUser() async {
    try {
      // Try to sign in anonymously
      UserCredential userCredential = await _auth.signInAnonymously();
      _userId = userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print("Failed to sign in anonymously: ${e.message}");
      // Fallback to using a locally stored ID
      _userId = await _getLocalUserId();
    }
    _checkUserCheckInStatus();
  }

  Future<String> _getLocalUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedId = prefs.getString('local_user_id');
    if (storedId == null) {
      storedId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('local_user_id', storedId);
    }
    return storedId;
  }

  Future<void> _checkUserCheckInStatus() async {
    if (_userId != null) {
      DocumentSnapshot userCheckIn = await _firestore
          .collection('user_check_ins')
          .doc(_userId)
          .get();
      setState(() {
        _hasCheckedIn = userCheckIn.exists;
      });
    }
  }

  Future<void> _checkIn() async {
    if (_userId != null && !_hasCheckedIn) {
      await _firestore.runTransaction((transaction) async {
        DocumentReference statsRef = _firestore.collection('stats').doc('check_ins');
        DocumentSnapshot statsSnapshot = await transaction.get(statsRef);
        
        if (!statsSnapshot.exists) {
          transaction.set(statsRef, {'count': 1});
        } else {
          int newCount = (statsSnapshot.data() as Map<String, dynamic>)['count'] + 1;
          transaction.update(statsRef, {'count': newCount});
        }
        
        transaction.set(_firestore.collection('user_check_ins').doc(_userId), {
          'checked_in': true,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });
      
      setState(() {
        _hasCheckedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Check-In Feature')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: _checkInsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _checkInCount = snapshot.data!.exists ? snapshot.data!.get('count') : 0;
                }
                return Text('Players Checked In: $_checkInCount');
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _hasCheckedIn ? null : _checkIn,
              child: Text(_hasCheckedIn ? 'Already Checked In' : 'Check In'),
            ),
          ],
        ),
      ),
    );
  }
}