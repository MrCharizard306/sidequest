import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
// location page

class ProximityDetectionPage extends StatefulWidget {
  @override
  _ProximityDetectionPageState createState() => _ProximityDetectionPageState();
}

class _ProximityDetectionPageState extends State<ProximityDetectionPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  StreamSubscription<Position>? _positionStreamSubscription;
  List<Map<String, dynamic>> _nearbyDevices = [];
  String _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
    _listenForNearbyDevices();
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      _updateLocation(position);
    });
  }

  void _updateLocation(Position position) {
    _database.child('locations/$_userId').set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': ServerValue.timestamp,
    });
  }

  void _listenForNearbyDevices() {
    _database.child('locations').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> locations = event.snapshot.value as Map<dynamic, dynamic>;
        _checkNearbyDevices(locations);
      }
    });
  }

  void _checkNearbyDevices(Map<dynamic, dynamic> locations) {
    List<Map<String, dynamic>> nearbyDevices = [];
    Position? myPosition;

    locations.forEach((key, value) {
      if (key == _userId) {
        myPosition = Position(
          latitude: value['latitude'],
          longitude: value['longitude'],
          timestamp: DateTime.fromMillisecondsSinceEpoch(value['timestamp']),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
    });

    if (myPosition != null) {
      locations.forEach((key, value) {
        if (key != _userId) {
          Position otherPosition = Position(
            latitude: value['latitude'],
            longitude: value['longitude'],
            timestamp: DateTime.fromMillisecondsSinceEpoch(value['timestamp']),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );

          double distance = Geolocator.distanceBetween(
            myPosition!.latitude,
            myPosition!.longitude,
            otherPosition.latitude,
            otherPosition.longitude,
          );

          if (distance <= 100) {
            nearbyDevices.add({
              'id': key,
              'distance': distance,
            });
          }
        }
      });

      setState(() {
        _nearbyDevices = nearbyDevices;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Devices')),
      body: ListView.builder(
        itemCount: _nearbyDevices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Device ${_nearbyDevices[index]['id']}'),
            subtitle: Text('Distance: ${_nearbyDevices[index]['distance'].toStringAsFixed(2)} meters'),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _database.child('locations/$_userId').remove();
    super.dispose();
  }
}