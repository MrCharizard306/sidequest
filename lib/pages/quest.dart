import 'package:flutter/material.dart';
import 'package:sidequest/main.dart';
import 'package:sidequest/pages/location_page.dart';

class QuestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quests', style: TextStyle(fontFamily: 'Itim')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '  Current Quest',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Itim',
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Type of Quest: Exploration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Itim',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Go outside and touch grass!!',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Itim',
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action for accepting the quest
                          Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LocationPage()),
    );
                        },
                        child: Text('Accept', style: TextStyle(fontFamily: 'Itim')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            Text(
              '  Incompleted Quests',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Itim',
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 10,
              
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    
                    Text(
                      'Type of Quest: Adventure',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Itim',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Complete a 5km run!',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Itim',
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action for retrying the quest
                        },
                        child: Text('Retry', style: TextStyle(fontFamily: 'Itim')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              
              elevation: 10,
              child: Padding(
                
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Type of Quest: Art',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Itim',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Visit the local art gallery',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Itim',
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action for retrying the quest
                          Navigator.pushNamed(context, '/locationpage');
                        },
                        child: Text('Retry', style: TextStyle(fontFamily: 'Itim')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}