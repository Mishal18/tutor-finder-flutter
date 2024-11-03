// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class SchedulePage extends StatefulWidget {
//   @override
//   _SchedulePageState createState() => _SchedulePageState();
// }

// class _SchedulePageState extends State<SchedulePage> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   List<Map<String, dynamic>> _scheduledClasses = [];
//   bool _isLoading = true; // Loading state
//   bool _isTutor = false; // Track if the user is a tutor

//   Future<void> _fetchUserRole() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       // Check if the user is a tutor
//       final tutorDoc =
//           await _firestore.collection('tutors').doc(user.uid).get();
//       setState(() {
//         _isTutor =
//             tutorDoc.exists; // If the document exists, the user is a tutor
//       });
//     }
//   }

//   Future<void> _fetchScheduledClasses() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       try {
//         // Determine the field to use in the query based on the user type
//         final fieldToQuery = _isTutor ? 'tutorId' : 'studentId';

//         // Fetch scheduled classes for the current user based on their role
//         final snapshot = await _firestore
//             .collection('scheduledClasses')
//             .where(fieldToQuery, isEqualTo: user.uid)
//             .get();

//         // Clear the previous data
//         _scheduledClasses.clear();

//         // Store the scheduled classes in a list
//         _scheduledClasses = await Future.wait(snapshot.docs.map((doc) async {
//           Map<String, dynamic> classData = doc.data();

//           // Fetch student details
//           final studentId = classData['studentId'];
//           final studentDoc =
//               await _firestore.collection('students').doc(studentId).get();

//           // Fetch tutor details
//           final tutorId = classData['tutorId'];
//           final tutorDoc =
//               await _firestore.collection('tutors').doc(tutorId).get();

//           // Set the student name if the document exists
//           classData['studentName'] = studentDoc.exists
//               ? studentDoc.data() != null
//                   ? ['name'] ?? 'Unknown Student'
//                   : 'Unknown Student'
//               :

//               // Set the tutor name if the document exists
//               classData['tutorName'] = tutorDoc.exists
//                   ? '${tutorDoc.data()?['firstName'] ?? ''} ${tutorDoc.data()?['lastName'] ?? ''}'
//                   : 'Unknown Tutor';

//           return classData;
//         }).toList());

//         setState(() {
//           _isLoading = false; // Update loading state
//         });
//       } catch (e) {
//         print('Error fetching scheduled classes: $e');
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } else {
//       setState(() {
//         _isLoading = false; // Update loading state if no user found
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserRole().then((_) =>
//         _fetchScheduledClasses()); // First fetch the user role, then fetch classes
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scheduled Classes'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator()) // Show loading indicator
//           : _scheduledClasses.isEmpty
//               ? Center(child: Text('No scheduled classes found.'))
//               : ListView.builder(
//                   itemCount: _scheduledClasses.length,
//                   itemBuilder: (context, index) {
//                     final classData = _scheduledClasses[index];

//                     return Card(
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Class with ${_isTutor ? classData['studentName'] : classData['tutorName']}',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'Tutor: ${classData['tutorName'] ?? 'Unknown Tutor'}',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             Text(
//                                 'Student: ${classData['studentName'] ?? 'Unknown Student'}',
//                                 style: TextStyle(fontSize: 16)),
//                             Text('Subject: ${classData['subject'] ?? 'N/A'}',
//                                 style: TextStyle(fontSize: 16)),
//                             Text('Class: ${classData['class'] ?? 'N/A'}',
//                                 style: TextStyle(fontSize: 16)),
//                             Text(
//                               'Date: ${classData['date'] != null ? DateFormat.yMd().format((classData['date'] as Timestamp).toDate()) : 'N/A'}',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             Text(
//                                 'Start Time: ${classData['startTime'] ?? 'N/A'}',
//                                 style: TextStyle(fontSize: 16)),
//                             Text('End Time: ${classData['endTime'] ?? 'N/A'}',
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _scheduledClasses = [];
  bool _isLoading = true; // Loading state
  bool _isTutor = false; // Track if the user is a tutor

  Future<void> _fetchUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Check if the user is a tutor
      final tutorDoc =
          await _firestore.collection('tutors').doc(user.uid).get();
      setState(() {
        _isTutor =
            tutorDoc.exists; // If the document exists, the user is a tutor
      });
    }
  }

  Future<void> _fetchScheduledClasses() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Determine the field to use in the query based on the user type
        final fieldToQuery = _isTutor ? 'tutorId' : 'studentId';

        // Fetch scheduled classes for the current user based on their role
        final snapshot = await _firestore
            .collection('scheduledClasses')
            .where(fieldToQuery, isEqualTo: user.uid)
            .get();

        // Clear the previous data
        _scheduledClasses.clear();

        // Store the scheduled classes in a list
        _scheduledClasses = await Future.wait(snapshot.docs.map((doc) async {
          Map<String, dynamic> classData = doc.data();

          // Fetch student details
          final studentId = classData['studentId'];
          final studentDoc =
              await _firestore.collection('students').doc(studentId).get();

          // Fetch tutor details
          final tutorId = classData['tutorId'];
          final tutorDoc =
              await _firestore.collection('tutors').doc(tutorId).get();

          // Set the student name if the document exists
          classData['studentName'] = studentDoc.exists
              ? studentDoc.data() != null
                  ? ['name'] ?? 'Unknown Student'
                  : 'Unknown Student'
              :

              // Set the tutor name if the document exists
              classData['tutorName'] = tutorDoc.exists
                  ? '${tutorDoc.data()?['firstName'] ?? ''} ${tutorDoc.data()?['lastName'] ?? ''}'
                  : 'Unknown Tutor';

          return classData;
        }).toList());

        setState(() {
          _isLoading = false; // Update loading state
        });
      } catch (e) {
        print('Error fetching scheduled classes: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false; // Update loading state if no user found
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserRole().then((_) =>
        _fetchScheduledClasses()); // First fetch the user role, then fetch classes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Scheduled Classes'),
      // ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _scheduledClasses.isEmpty
              ? Center(child: Text('No scheduled classes found.'))
              : ListView.builder(
                  itemCount: _scheduledClasses.length,
                  itemBuilder: (context, index) {
                    final classData = _scheduledClasses[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Class with ${_isTutor ? classData['studentName'] : classData['tutorName']}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tutor: ${classData['tutorName'] ?? 'Unknown Tutor'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                                'Student: ${classData['studentName'] ?? 'Unknown Student'}',
                                style: TextStyle(fontSize: 16)),
                            Text('Subject: ${classData['subject'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            Text('Class: ${classData['class'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            Text(
                              'Date: ${classData['date'] != null ? DateFormat.yMd().format((classData['date'] as Timestamp).toDate()) : 'N/A'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                                'Start Time: ${classData['startTime'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            Text('End Time: ${classData['endTime'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
