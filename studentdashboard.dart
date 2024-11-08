import 'package:flutter/material.dart';
import 'package:testing/screens/studentprofile.dart';
import 'package:testing/screens/tutorshedule.dart';
import 'package:testing/screens/messages.dart';
import 'package:testing/screens/tutorspage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for user ID

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  int _currentSelectedIndex = 0;
  bool _isCollapsed = true; // State for sidebar collapse/expand
  final _pages = [
    StudentProfilePage(studentId: FirebaseAuth.instance.currentUser!.uid),
    TutorsPage(), // Pass tutorId here
    SchedulePage(),
    MessagesPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Finder'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          _pages[_currentSelectedIndex], // Main content area
          // _buildCollapsibleSidebar(), // Sidebar overlay
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.green,
        currentIndex: _currentSelectedIndex,
        onTap: (newIndex) {
          setState(() {
            _currentSelectedIndex = newIndex;
            if (newIndex == 2) {
              // Toggle sidebar for "Account"
              _isCollapsed = !_isCollapsed;
            } else {
              _isCollapsed = true;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tutors'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
        ],
      ),
    );
  }
}
