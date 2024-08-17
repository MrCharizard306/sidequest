import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScoreCalculator(),
    );
  }
}

class ScoreCalculator extends StatefulWidget {
  @override
  _ScoreCalculatorState createState() => _ScoreCalculatorState();
}

class _ScoreCalculatorState extends State<ScoreCalculator> {
  int rawScore = 0;
  double calculatedScore = 0;
  String imageAsset = 'assets/images/level1.png';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchScoreFromFirestore();
  }

  void fetchScoreFromFirestore() async {
    try {
      // Replace 'scores' with your actual collection name
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('stats')
          .doc('check_ins')
          .get();

      if (snapshot.exists) {
        // Explicitly cast to int
        rawScore = (snapshot.get('count') as num).toInt();
        updateScore();
      } else {
        setError('No score found in Firestore');
      }
    } catch (e) {
      setError('Error fetching score: $e');
    }
  }

  void setError(String message) {
    setState(() {
      errorMessage = message;
      isLoading = false;
    });
  }

  void updateScore() {
    setState(() {
      if (rawScore <= 10) {
        calculatedScore = rawScore.toDouble();
      } else {
        calculatedScore = 10 + log(rawScore - 9) / log(1.5);
      }
      updateImage();
      isLoading = false;
    });
  }

  void updateImage() {
    if (calculatedScore < 1) {
      imageAsset = 'assets/images/level1.png';
    } else if (calculatedScore < 3) {
      imageAsset = 'assets/images/level2.png';
    } else if (calculatedScore < 5) {
      imageAsset = 'assets/images/level3.png';
    } else {
      imageAsset = 'assets/images/level4.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score Calculator'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage.isNotEmpty
                ? Text(errorMessage, style: TextStyle(color: Colors.red))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Raw Score: $rawScore',
                          style: TextStyle(fontSize: 24)),
                      SizedBox(height: 10),
                      Text('Calculated Score: ${calculatedScore.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 24)),
                      SizedBox(height: 20),
                      Image.asset(imageAsset, width: 200, height: 200),
                    ],
                  ),
      ),
    );
  }
}