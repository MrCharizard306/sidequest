import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'package:sidequest/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ScoreCalculator extends StatefulWidget {
  const ScoreCalculator({Key? key}) : super(key: key);

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
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setError('No user logged in');
        return;
      }

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('deviceCounts')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        rawScore = (data['count'] as num).toInt();
        updateScore();
      } else {
        setError('No score found for this user');
      }
    } catch (e) {
      setError('Error fetching score: $e');
    }
  }

  void updateScore() {
     if (mounted) {
       setState(() {
         if (rawScore <= 100) {
           calculatedScore = 100 + (rawScore.toDouble());
         } else {
           calculatedScore = 100 + rawScore*1.2;
         }
         updateImage();
         isLoading = false;
       });
     }
   }

   void setError(String message) {
     if (mounted) {
       setState(() {
         errorMessage = message;
         isLoading = false;
       });
     }
   }

  int get level {
    return (calculatedScore / 50).floor() + 1;
  }

  double get xpPercentage {
    return (calculatedScore % 50) / 50;
  }

  int get xpForNextLevel {
    return 50 - (calculatedScore % 50).floor();
  }

  void updateImage() {
    if (level <= 1) {
      imageAsset = 'assets/images/level1.JPEG';
    } else if (level == 2) {
      imageAsset = 'assets/images/level2.JPEG';
    } else if (level == 3) {
      imageAsset = 'assets/images/level3.JPEG';
    } else {
      imageAsset = 'assets/images/level4.JPEG';
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Page', style: TextStyle(fontFamily: 'Itim')),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  },
),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage.isNotEmpty
                ? Text(errorMessage, style: TextStyle(color: Colors.red))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(height: 10),
                      Text(' Score: ${calculatedScore.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 24, fontFamily: 'Itim')),
                      SizedBox(height: 20),
                      Image.asset(
                        imageAsset,
                        width: 200,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Column(
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 50),
                              Text('Error loading image: $imageAsset',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text('Level $level',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 40, // Full width minus padding
                          lineHeight: 20.0,
                          percent: xpPercentage,
                          center: Text(
                            "${(xpPercentage * 100).toStringAsFixed(1)}%",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          backgroundColor: Colors.white,
                          progressColor: Colors.blue,
                          barRadius: Radius.circular(10),
                          padding: EdgeInsets.symmetric(horizontal: 10), // Keep some padding within the bar
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('${xpForNextLevel} XP to next level',
                          style: TextStyle(fontSize: 16, fontFamily: 'Itim')),
                    ],
                  ),
      ),
    );
  }
}