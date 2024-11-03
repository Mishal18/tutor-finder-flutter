import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorVerificationPage extends StatefulWidget {
  @override
  _TutorVerificationPageState createState() => _TutorVerificationPageState();
}

class _TutorVerificationPageState extends State<TutorVerificationPage> {
  // Stream to listen for changes in the 'tutors' collection with isVerified set to false
  late Stream<QuerySnapshot<Map<String, dynamic>>> unverifiedTutorsStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to listen to changes in the 'tutors' collection with only unverified tutors
    unverifiedTutorsStream = FirebaseFirestore.instance
        .collection('tutors')
        .where('isVerified', isEqualTo: false)
        .snapshots();
  }

  // Function to launch the URL in a web view
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the document URL.')),
      );
    }
  }

  // Show confirmation dialog before verifying or declining tutor
  Future<void> _showConfirmationDialog(
      {required String tutorId,
      required String action,
      required Function onConfirm}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$action Tutor'),
          content: Text('Are you sure you want to $action this tutor?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tutor successfully $action.')),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: unverifiedTutorsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // If data is available, display it
          final unverifiedTutors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: unverifiedTutors.length,
            itemBuilder: (context, index) {
              final tutorData = unverifiedTutors[index].data();
              final tutorId = unverifiedTutors[index].id;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tutorData['firstName']} ${tutorData['lastName']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text('Email: ${tutorData['email']}'),
                      Text('Phone: ${tutorData['number']}'),
                      Text('Qualification: ${tutorData['qualification']}'),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          _launchURL(tutorData['qualificationDocumentUrl']);
                        },
                        child: Text('View Document'),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _showConfirmationDialog(
                                tutorId: tutorId,
                                action: 'Verify',
                                onConfirm: () {
                                  FirebaseFirestore.instance
                                      .collection('tutors')
                                      .doc(tutorId)
                                      .update({'isVerified': true})
                                      .then((value) => print('Tutor verified'))
                                      .catchError((error) => print(
                                          'Failed to verify tutor: $error'));
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Verify'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showConfirmationDialog(
                                tutorId: tutorId,
                                action: 'Decline',
                                onConfirm: () {
                                  FirebaseFirestore.instance
                                      .collection('tutors')
                                      .doc(tutorId)
                                      .delete()
                                      .then((value) => print('Tutor declined'))
                                      .catchError((error) => print(
                                          'Failed to decline tutor: $error'));
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Decline'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
