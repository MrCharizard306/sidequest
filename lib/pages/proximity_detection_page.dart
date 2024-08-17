import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class ProximityDetectionPage extends StatefulWidget {
  final ProximityDetectionLogic logic;

  ProximityDetectionPage({Key? key, ProximityDetectionLogic? logic})
      : logic = logic ?? ProximityDetectionLogic(),
        super(key: key);

  @override
  _ProximityDetectionPageState createState() => _ProximityDetectionPageState();
}

class _ProximityDetectionPageState extends State<ProximityDetectionPage> {
  List<Map<String, dynamic>> _nearbyDevices = [];
  bool _isLocationEnabled = false;
  String _lastUpdated = '';
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationService();
    widget.logic.startLocationUpdates((position) {
      setState(() {
        _currentPosition = position;
        _lastUpdated = DateTime.now().toString();
      });
    });
    widget.logic.listenForNearbyDevices((devices) {
      setState(() {
        _nearbyDevices = devices;
        _lastUpdated = DateTime.now().toString();
      });
    });
  }

  void _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isLocationEnabled = serviceEnabled;
    });
  }

  void _refreshLocation() {
    widget.logic.refreshLocation();
    _checkLocationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Devices')),
      body: Column(
        children: [
          _buildStatusBar(),
          _buildDebugInfo(),
          Expanded(child: _buildDeviceList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshLocation,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: _isLocationEnabled ? Colors.green : Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _isLocationEnabled ? 'Location Enabled' : 'Location Disabled',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Nearby Devices: ${_nearbyDevices.length}',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugInfo() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Last Updated: $_lastUpdated'),
          if (_currentPosition != null)
            Text('Current Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}'),
        ],
      ),
    );
  }

  Widget _buildDeviceList() {
    return ListView.builder(
      itemCount: _nearbyDevices.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Device ${_nearbyDevices[index]['id']}'),
          subtitle: Text('Distance: ${_nearbyDevices[index]['distance'].toStringAsFixed(2)} meters'),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.logic.dispose();
    super.dispose();
  }
}

class ProximityDetectionLogic {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final String _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
  Function(Position)? _onLocationUpdate;

  void startLocationUpdates(Function(Position) onLocationUpdate) {
    _onLocationUpdate = onLocationUpdate;
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen(_handleLocationUpdate);
  }

  void _handleLocationUpdate(Position position) {
    _updateLocation(position);
    if (_onLocationUpdate != null) {
      _onLocationUpdate!(position);
    }
  }

  void _updateLocation(Position position) {
    _database.child('locations/$_userId').set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': ServerValue.timestamp,
    });
  }

  void refreshLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _handleLocationUpdate(position);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void listenForNearbyDevices(Function(List<Map<String, dynamic>>) onDevicesUpdated) {
    _database.child('locations').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> locations = event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> nearbyDevices = checkNearbyDevices(locations, _userId);
        onDevicesUpdated(nearbyDevices);
      }
    });
  }

  List<Map<String, dynamic>> checkNearbyDevices(Map<dynamic, dynamic> locations, String currentUserId) {
    List<Map<String, dynamic>> nearbyDevices = [];
    Map<String, dynamic>? myLocation;

    locations.forEach((key, value) {
      if (key == currentUserId) {
        myLocation = {
          'latitude': value['latitude'],
          'longitude': value['longitude'],
        };
      }
    });

    if (myLocation != null) {
      locations.forEach((key, value) {
        if (key != currentUserId) {
          double distance = calculateDistance(
            myLocation!['latitude'], myLocation!['longitude'],
            value['latitude'], value['longitude']
          );

          if (distance <= 100) {
            nearbyDevices.add({
              'id': key,
              'distance': distance,
            });
          }
        }
      });
    }

    return nearbyDevices;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  void dispose() {
    _database.child('locations/$_userId').remove();
  }
}