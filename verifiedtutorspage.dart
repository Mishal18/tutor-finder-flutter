import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifiedTutorsPage extends StatefulWidget {
  @override
  _VerifiedTutorsPageState createState() => _VerifiedTutorsPageState();
}

class _VerifiedTutorsPageState extends State<VerifiedTutorsPage> {
  // Stream to listen for changes in the 'tutors' collection with isVerified set to true
  late Stream<QuerySnapshot<Map<String, dynamic>>> verifiedTutorsStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to listen to changes in the 'tutors' collection with only verified tutors
    verifiedTutorsStream = FirebaseFirestore.instance
        .collection('tutors')
        .where('isVerified', isEqualTo: true)
        .snapshots();
  }

  // Function to launch the URL in a web view
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launchUrl(Uri.parse(url)); // Parse the String into a Uri
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Verified Tutors'),
      // ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: verifiedTutorsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // If data is available, display it
          final verifiedTutors = snapshot.data!.docs;

          if (verifiedTutors.isEmpty) {
            return Center(child: Text('No verified tutors available.'));
          }

          return ListView.builder(
            itemCount: verifiedTutors.length,
            itemBuilder: (context, index) {
              final tutorData = verifiedTutors[index].data();
              final tutorId = verifiedTutors[index].id; // Get tutor ID

              return Card(
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tutorData['firstName']} ${tutorData['lastName']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Email: ${tutorData['email']}'),
                      Text('Phone: ${tutorData['number']}'),
                      Text('Qualification: ${tutorData['qualification']}'),
                      SizedBox(height: 10),
                      // Add a button to view the qualification document
                      TextButton(
                        onPressed: () {
                          // Launch the URL in a web view
                          _launchURL(tutorData['qualificationDocumentUrl']);
                        },
                        child: Text('View Qualification Document'),
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
