import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testing/screens/editstudentprofile.dart';

class StudentProfilePage extends StatefulWidget {
  final String studentId;

  const StudentProfilePage({Key? key, required this.studentId})
      : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  DocumentSnapshot? studentData;

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    studentData = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (studentData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Extract data from the document
    String firstName = studentData!['firstName'] ?? 'N/A';
    String lastName = studentData!['lastName'] ?? 'N/A';
    String phoneNumber = studentData!['number'] ?? 'N/A';
    String email = studentData!['email'] ?? 'N/A';
    String profileImageURL = studentData!['profileImageUrl'] is String
        ? studentData!['profileImageUrl']
        : '';
    return Scaffold(
      // Removed appBar: AppBar(
      //   title: Text('Student Profile'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImageURL.isNotEmpty
                      ? NetworkImage(profileImageURL)
                      : AssetImage('assets/images/avatar.png') as ImageProvider,
                ),
              ), // You can add a CircleAvatar here if you have a profileImageURL in your 'students' collection
              // ...

              SizedBox(height: 20),
              Text(
                '$firstName $lastName',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Phone Number: $phoneNumber',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Email: $email',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Edit Profile Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditStudentProfilePage(
                        studentId: widget.studentId,
                        onRefresh: _fetchStudentData,
                      ),
                    ),
                  );
                },
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ... (EditStudentProfilePage code remains the same) ...