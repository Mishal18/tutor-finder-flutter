import 'package:flutter/material.dart';
import 'package:testing/screens/tutor_verification_page.dart';
import 'package:testing/screens/verifiedtutorspage.dart';
import 'package:testing/screens/paymentmanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'adminlogin.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  int _currentSelectedIndex = 0;
  final _pages = [
    TutorVerificationPage(),
    VerifiedTutorsPage(),
    AdminPaymentManagementPage(),
  ];

  final _pageTitles = [
    'Tutor Verification',
    'Verified Tutors',
    'Payment Management',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentSelectedIndex]),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginPage()),
                );
              } catch (e) {
                print('Error signing out: ${e.toString()}');
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _pages[_currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.green,
        currentIndex: _currentSelectedIndex,
        onTap: (newIndex) {
          setState(() {
            _currentSelectedIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tutors'),
          BottomNavigationBarItem(
              icon: Icon(Icons.verified), label: 'Verified'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Payments'),
        ],
      ),
    );
  }
}
