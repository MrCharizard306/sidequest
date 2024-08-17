import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Sharing App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PhotoFeedScreen(),
    );
  }
}

class PhotoFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Feed')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('photos')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return PhotoCard(
                imageUrl: data['url'],
                caption: data['caption'],
                userId: data['userId'],
                timestamp: (data['timestamp'] as Timestamp).toDate(),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PhotoSharingScreen()),
          );
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  final String imageUrl;
  final String caption;
  final String userId;
  final DateTime timestamp;

  PhotoCard({
    required this.imageUrl,
    required this.caption,
    required this.userId,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(caption, style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text(
                  'Posted by $userId on ${timestamp.toString()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoSharingScreen extends StatefulWidget {
  @override
  _PhotoSharingScreenState createState() => _PhotoSharingScreenState();
}

class _PhotoSharingScreenState extends State<PhotoSharingScreen> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadImage() async {
    if (_image == null) return;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('photos/$fileName');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('photos').add({
        'url': downloadURL,
        'userId': 'current_user_id', // Replace with actual user ID
        'timestamp': FieldValue.serverTimestamp(),
        'caption': _captionController.text,
      });

      print('Image uploaded successfully');
      Navigator.pop(context); // Return to feed after upload
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Share a Photo')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Select Image'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  hintText: 'Enter a caption...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}