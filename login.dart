import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'studentdashboard.dart'; // Import your Student Dashboard page
import 'tutordashboard.dart'; // Import your Tutor Dashboard page

class LoginPage extends StatefulWidget {
  final String role;

  LoginPage({required this.role});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showAlertDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple, Colors.cyan],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${widget.role.toUpperCase()} LOGIN',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 50),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter your Email',
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter your Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        // Sign in the user with email and password
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );

                        // Check the role and redirect accordingly
                        if (widget.role == 'Student') {
                          // Fetch student details from Firestore
                          final userDoc = await FirebaseFirestore.instance
                              .collection('students')
                              .doc(userCredential.user!.uid)
                              .get();

                          // Verify if the student exists in the Firestore database
                          if (userDoc.exists) {
                            // Redirect to the student dashboard
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentDashboard(),
                              ),
                            );
                          } else {
                            // Show an error message if the details don't match
                            _showAlertDialog('Invalid credentials.');
                          }
                        } else if (widget.role == 'Tutor') {
                          // Fetch tutor details from Firestore
                          final userDoc = await FirebaseFirestore.instance
                              .collection('tutors')
                              .doc(userCredential.user!.uid)
                              .get();

                          // Verify if the tutor exists in the Firestore database and is verified
                          if (userDoc.exists && userDoc.data()!['isVerified']) {
                            // Redirect to the tutor dashboard
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          } else {
                            // Show an error message if the details don't match or tutor is not verified
                            _showAlertDialog(
                                'Invalid credentials or tutor is not verified.');
                          }
                        }
                      } catch (e) {
                        print('Error signing in: ${e.toString()}');
                        _showAlertDialog('Invalid credentials.');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 10),
                if (widget.role == 'Student')
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/studentSignup');
                    },
                    child: Text(
                      'Don’t have an account? Sign up as student',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (widget.role == 'Tutor') // Sign Up option for Tutors
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/tutorSignup');
                    },
                    child: Text(
                      'Don’t have an account? Sign up as tutor',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
