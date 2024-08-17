import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Devices App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign in Anonymously'),
          onPressed: () async {
            await _signInAnonymously();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NearbyDevicesPage()),
            );
          },
        ),
      ),
    );
  }
}

class NearbyDevicesPage extends StatefulWidget {
  @override
  _NearbyDevicesPageState createState() => _NearbyDevicesPageState();
}

class _NearbyDevicesPageState extends State<NearbyDevicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _nearbyDevices = 0;
  bool _isLocationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return;
    } 

    setState(() {
      _isLocationPermissionGranted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Devices')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLocationPermissionGranted)
              ElevatedButton(
                onPressed: _recordLocation,
                child: Text('Record My Location'),
              )
            else
              Text('Location permission not granted'),
            SizedBox(height: 20),
            Text('Nearby Devices: $_nearbyDevices'),
          ],
        ),
      ),
    );
  }

  Future<void> _recordLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('locations').doc(user.uid).set({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _checkNearbyDevices(position);
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error recording location: $e');
    }
  }

  Future<void> _checkNearbyDevices(Position myPosition) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('locations').get();

      int count = 0;
      for (var doc in snapshot.docs) {
        if (doc.id != _auth.currentUser?.uid) {
          double distance = Geolocator.distanceBetween(
            myPosition.latitude,
            myPosition.longitude,
            doc['latitude'],
            doc['longitude'],
          );

          if (distance <= 100) {
            count++;
          }
        }
      }

      setState(() {
        _nearbyDevices = count;
      });
    } catch (e) {
      print('Error checking nearby devices: $e');
    }
  }
}