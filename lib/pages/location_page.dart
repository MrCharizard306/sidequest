import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sidequest/components/my_button.dart';
import 'package:sidequest/pages/home_page.dart';
import 'package:sidequest/pages/photo_page.dart';
import 'dart:async';

import '../main.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Devices App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NearbyDevicesPage(),
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
  Timer? _timer;
  Position? _lastKnownPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

    // Start periodic checking
    _startPeriodicChecking();
  }

  void _startPeriodicChecking() {
    // Check every 30 seconds
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _updateLocationAndCheck();
    });
  }

  Future<void> _updateLocationAndCheck() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _lastKnownPosition = position;

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
      print('Error updating location: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Devices', style: TextStyle(fontFamily: 'Itim')),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  ),
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLocationPermissionGranted)
              Text('Checking for nearby devices every 30 seconds', style: TextStyle(fontFamily: 'Itim'))
          else
              Text('Location permission not granted', style: TextStyle(fontFamily: 'Itim')),
            SizedBox(height: 20),
            Text('Nearby Devices: $_nearbyDevices', style: TextStyle(fontFamily: 'Itim')),
            SizedBox(height: 20), 
            ElevatedButton(
              onPressed: _updateLocationAndCheck,
              child: Text('Check Now', style: TextStyle(fontFamily: 'Itim')),
            ),
          
         SizedBox(height: 20),
        ElevatedButton(
        onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PhotoPage()),
          );
       },
       child: Text("Start Quest", style: TextStyle(fontFamily: 'Itim')),
),
            
          ],
        ),
      ),
    );
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

      // Store the count in Firebase
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('deviceCounts').doc(user.uid).set({
          'count': count,
          'timestamp': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      setState(() {
        _nearbyDevices = count;
      });
    } catch (e) {
      print('Error checking nearby devices: $e');
    }
  }
}