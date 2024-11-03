import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edittutorprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tutorshedule.dart';
import 'package:intl/intl.dart';

class TutorProfilePage extends StatefulWidget {
  final String tutorId;
  final String userRole;

  const TutorProfilePage({
    Key? key,
    required this.tutorId,
    required this.userRole,
  }) : super(key: key);

  @override
  _TutorProfilePageState createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  DocumentSnapshot? tutorData;
  String? selectedSubject;
  String? selectedClass;
  AvailableTime? selectedAvailableTime;

  List<AvailableTime> availableTimes = [];
  List<AvailableTime> scheduledTimes = [];

  @override
  void initState() {
    super.initState();
    _fetchTutorData();
    _fetchScheduledClasses();
  }

  Future<void> _fetchTutorData() async {
    tutorData = await FirebaseFirestore.instance
        .collection('tutors')
        .doc(widget.tutorId)
        .get();
    _populateAvailableTimes();
    setState(() {});
  }

  Future<void> _fetchScheduledClasses() async {
    QuerySnapshot scheduledClassesSnapshot = await FirebaseFirestore.instance
        .collection('scheduledClasses')
        .where('tutorId', isEqualTo: widget.tutorId)
        .get();

    scheduledTimes = scheduledClassesSnapshot.docs.map((doc) {
      DateTime date = (doc['date'] as Timestamp).toDate();
      String startTime = doc['startTime'] ?? 'N/A';
      String endTime = doc['endTime'] ?? 'N/A';
      return AvailableTime(date: date, start: startTime, end: endTime);
    }).toList();

    setState(() {});
  }

  void _populateAvailableTimes() {
    availableTimes.clear();
    if (tutorData != null) {
      dynamic availableDaysData = tutorData!['availableDays'];
      if (availableDaysData is List) {
        for (var day in availableDaysData) {
          DateTime date = (day['date'] as Timestamp).toDate();
          String startTime = day['availableTime']['start'] ?? 'N/A';
          String endTime = day['availableTime']['end'] ?? 'N/A';
          availableTimes
              .add(AvailableTime(date: date, start: startTime, end: endTime));
        }
      }
    }
  }

  bool isScheduled(AvailableTime availableTime) {
    for (var scheduledTime in scheduledTimes) {
      if (scheduledTime.date == availableTime.date &&
          scheduledTime.start == availableTime.start &&
          scheduledTime.end == availableTime.end) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (tutorData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Adding null checks to fields that may be missing
    String firstName = tutorData!['firstName'] as String? ?? 'N/A';
    String lastName = tutorData!['lastName'] as String? ?? 'N/A';
    String qualification = tutorData!['qualification'] as String? ?? 'N/A';
    String email = tutorData!['email'] as String? ?? 'N/A';
    String profileImageURL = tutorData!['profileImageURL'] as String? ?? '';

    // Subjects and Classes are assumed to be lists, but default to empty lists if null
    List<String> subjects = [];
    dynamic subjectsData = tutorData!['subjects'];
    if (subjectsData is List) {
      subjects =
          List<String>.from(subjectsData.map((subject) => subject.toString()));
    }

    List<String> classes = [];
    dynamic classesData = tutorData!['classes'];
    if (classesData is List) {
      classes =
          List<String>.from(classesData.map((classNum) => classNum.toString()));
    }

    return Scaffold(
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
              ),
              SizedBox(height: 10),
              Text(
                '$firstName $lastName',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Qualification: $qualification',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Email: $email',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),

              // Subjects Section
              if (subjects.isNotEmpty) ...[
                Text(
                  'Subjects:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: subjects.map((subject) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSubject =
                              selectedSubject == subject ? null : subject;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedSubject == subject
                              ? Colors.blue[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(subject),
                      ),
                    );
                  }).toList(),
                ),
              ],

              SizedBox(height: 15),

              // Classes Section
              if (classes.isNotEmpty) ...[
                Text(
                  'Classes:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: classes.map((classNum) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedClass =
                              selectedClass == classNum ? null : classNum;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedClass == classNum
                              ? Colors.blue[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Class $classNum'),
                      ),
                    );
                  }).toList(),
                ),
              ],

              SizedBox(height: 15),

              // Available Times Section
              if (availableTimes.isNotEmpty) ...[
                Text(
                  'Available Times:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: availableTimes.map((availableTime) {
                    bool scheduled = isScheduled(availableTime);
                    return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scheduled ? Colors.red[200] : Colors.green[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat.yMd().format(availableTime.date),
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${availableTime.start} - ${availableTime.end}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTutorProfilePage(
                        tutorId: widget.tutorId,
                        onRefresh: _fetchTutorData,
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

class AvailableTime {
  final DateTime date;
  final String start;
  final String end;

  AvailableTime({required this.date, required this.start, required this.end});
}
