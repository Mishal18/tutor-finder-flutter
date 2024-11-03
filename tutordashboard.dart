import 'package:flutter/material.dart';
import 'package:testing/screens/tutorprofile.dart';
import 'package:testing/screens/tutorshedule.dart';
import 'package:testing/screens/messages.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for user ID
import 'login.dart'; // Assuming this is your login page

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentSelectedIndex = 0;
  bool _isCollapsed = true; // State for sidebar collapse/expand
  final _pages = [
    TutorProfilePage(
      tutorId: FirebaseAuth.instance.currentUser!.uid,
      userRole: 'tutor',
    ), // Pass tutorId here
    SchedulePage(),
    MessagesPage()
  ];

  // Titles for each page
  final List<String> _pageTitles = [
    'My Profile',
    'Scheduled Classes',
    'Messages'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentSelectedIndex]), // Dynamic title
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Logout Button
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                // Navigate to the login page after logout
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(
                            role: 'tutor',
                          )),
                );
              } catch (e) {
                print('Error signing out: ${e.toString()}');
                // You might want to show an error message to the user
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          _pages[_currentSelectedIndex], // Main content area
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
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
        ],
      ),
    );
  }
}
