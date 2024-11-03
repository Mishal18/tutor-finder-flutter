// // import 'dart:io';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:file_picker/file_picker.dart'; // Import for file picker
// // import 'package:path/path.dart' as path; // Import for getting file name
// // import 'login.dart'; // Assuming this is your login page

// // class TutorSignUpPage extends StatefulWidget {
// //   @override
// //   _TutorSignUpPageState createState() => _TutorSignUpPageState();
// // }

// // class _TutorSignUpPageState extends State<TutorSignUpPage> {
// //   bool _isPasswordVisible = false;
// //   final _formKey = GlobalKey<FormState>();
// //   final _firstNameController = TextEditingController();
// //   final _lastNameController = TextEditingController();
// //   final _emailController = TextEditingController();
// //   final _numberController = TextEditingController();
// //   final _qualificationController = TextEditingController();
// //   final _passwordController = TextEditingController();

// //   File? _pickedFile; // File for the uploaded document

// //   @override
// //   void dispose() {
// //     _firstNameController.dispose();
// //     _lastNameController.dispose();
// //     _emailController.dispose();
// //     _numberController.dispose();
// //     _qualificationController.dispose();
// //     _passwordController.dispose();
// //     super.dispose();
// //   }

// //   // Function to pick file using file_picker
// //   Future<void> _pickFile() async {
// //     FilePickerResult? result = await FilePicker.platform.pickFiles(
// //       type: FileType.custom,
// //       allowedExtensions: ['pdf'],
// //     );
// //     if (result != null) {
// //       setState(() {
// //         _pickedFile = File(result.files.single.path!);
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             colors: [Colors.purple, Colors.cyan],
// //           ),
// //         ),
// //         child: SingleChildScrollView(
// //           // Use SingleChildScrollView to allow scrolling
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Form(
// //               key: _formKey,
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: <Widget>[
// //                   Text(
// //                     'TUTOR SIGN UP',
// //                     style: TextStyle(
// //                       fontSize: 36,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                   SizedBox(height: 50),
// //                   TextFormField(
// //                     controller: _firstNameController,
// //                     decoration: InputDecoration(
// //                       labelText: 'First Name',
// //                       labelStyle: TextStyle(color: Colors.white),
// //                       hintText: 'Enter your First Name',
// //                     ),
// //                     style: TextStyle(color: Colors.white),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your first name';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   SizedBox(height: 20),
// //                   TextFormField(
// //                     controller: _lastNameController,
// //                     decoration: InputDecoration(
// //                       labelText: 'Last Name',
// //                       labelStyle: TextStyle(color: Colors.white),
// //                       hintText: 'Enter your Last Name',
// //                     ),
// //                     style: TextStyle(color: Colors.white),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your last name';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   SizedBox(height: 20),
// //                   TextFormField(
// //                     controller: _emailController,
// //                     decoration: InputDecoration(
// //                       labelText: 'Email',
// //                       labelStyle: TextStyle(color: Colors.white),
// //                       hintText: 'Enter your Email',
// //                     ),
// //                     style: TextStyle(color: Colors.white),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your email';
// //                       }
// //                       if (!value.contains('@')) {
// //                         return 'Please enter a valid email';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   SizedBox(height: 20),
// //                   TextFormField(
// //                     controller: _numberController,
// //                     keyboardType: TextInputType.phone,
// //                     decoration: InputDecoration(
// //                       labelText: 'Phone Number',
// //                       labelStyle: TextStyle(color: Colors.white),
// //                       hintText: 'Enter your Phone Number',
// //                     ),
// //                     style: TextStyle(color: Colors.white),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your phone number';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   SizedBox(height: 20),
// //                   TextFormField(
// //                     controller: _qualificationController,
// //                     decoration: InputDecoration(
// //                       labelText: 'Highest Qualification',
// //                       labelStyle: TextStyle(color: Colors.white),
// //                       hintText: 'Enter your Highest Qualification',
// //                     ),
// //                     style: TextStyle(color: Colors.white),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your highest qualification';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   SizedBox(height: 20),
// //                   ElevatedButton(
// //                     onPressed: _pickFile,
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.white,
// //                       foregroundColor: Colors.black,
// //                     ),
// //                     child: Text('Upload Highest Qualification Document'),
// //                   ),
// //                   if (_pickedFile != null)
// //                     Text(
// //                       'File Selected: ${path.basename(_pickedFile!.path)}', // Show file name
// //                       style: TextStyle(color: Colors.white),
// //                     ),
// //                   SizedBox(height: 20),
// //                   TextFormField(
// //                     controller: _passwordController,
// //                     obscureText: !_isPasswordVisible,
// //                     decoration: InputDecoration(
// //                       labelText: 'Password',
// //                       labelStyle: TextStyle(color: Colors.white),
// //                       hintText: 'Enter your Password',
// //                       suffixIcon: IconButton(
// //                         icon: Icon(
// //                           _isPasswordVisible
// //                               ? Icons.visibility
// //                               : Icons.visibility_off,
// //                           color: Colors.white,
// //                         ),
// //                         onPressed: () {
// //                           setState(() {
// //                             _isPasswordVisible = !_isPasswordVisible;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                     style: TextStyle(color: Colors.white),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter your password';
// //                       }
// //                       if (value.length < 6) {
// //                         return 'Password must be at least 6 characters';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   SizedBox(height: 30),
// //                   ElevatedButton(
// //                     onPressed: () async {
// //                       if (_formKey.currentState!.validate() &&
// //                           _pickedFile != null) {
// //                         try {
// //                           // Create user with email and password
// //                           final userCredential = await FirebaseAuth.instance
// //                               .createUserWithEmailAndPassword(
// //                             email: _emailController.text.trim(),
// //                             password: _passwordController.text.trim(),
// //                           );

// //                           // Upload document to Firebase Storage
// //                           final storageRef = FirebaseStorage.instance
// //                               .ref()
// //                               .child('tutor_documents')
// //                               .child(userCredential.user!.uid)
// //                               .child('qualification.pdf');
// //                           await storageRef.putFile(_pickedFile!);
// //                           final downloadUrl = await storageRef.getDownloadURL();

// //                           // Add tutor data to Firestore
// //                           await FirebaseFirestore.instance
// //                               .collection('tutors')
// //                               .doc(userCredential.user!.uid)
// //                               .set({
// //                             'firstName': _firstNameController.text.trim(),
// //                             'lastName': _lastNameController.text.trim(),
// //                             'email': _emailController.text.trim(),
// //                             'number': _numberController.text.trim(),
// //                             'qualification':
// //                                 _qualificationController.text.trim(),
// //                             'qualificationDocumentUrl': downloadUrl,
// //                             'isVerified': false, // Initially set to false
// //                           });

// //                           // Navigate to login page
// //                           Navigator.pushReplacement(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => LoginPage(role: 'tutor'),
// //                             ),
// //                           );
// //                         } catch (e) {
// //                           print('Error creating user: ${e.toString()}');
// //                           // Show an error message to the user
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             SnackBar(content: Text('Failed to create tutor.')),
// //                           );
// //                         }
// //                       }
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.white,
// //                       foregroundColor: Colors.black,
// //                       padding:
// //                           EdgeInsets.symmetric(horizontal: 50, vertical: 15),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                     ),
// //                     child: Text('Sign Up'),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:file_picker/file_picker.dart'; // Import for file picker
// import 'package:path/path.dart' as path; // Import for getting file name
// import 'login.dart'; // Assuming this is your login page

// class TutorSignUpPage extends StatefulWidget {
//   @override
//   _TutorSignUpPageState createState() => _TutorSignUpPageState();
// }

// class _TutorSignUpPageState extends State<TutorSignUpPage> {
//   bool _isPasswordVisible = false;
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _numberController = TextEditingController();
//   final _qualificationController = TextEditingController();
//   final _passwordController = TextEditingController();

//   File? _pickedFile; // File for the uploaded document

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _numberController.dispose();
//     _qualificationController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Function to pick file using file_picker
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//     if (result != null) {
//       setState(() {
//         _pickedFile = File(result.files.single.path!);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.purple, Colors.cyan],
//           ),
//         ),
//         child: SingleChildScrollView(
//           // Use SingleChildScrollView to allow scrolling
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     'TUTOR SIGN UP',
//                     style: TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 50),
//                   TextFormField(
//                     controller: _firstNameController,
//                     decoration: InputDecoration(
//                       labelText: 'First Name',
//                       labelStyle: TextStyle(color: Colors.white),
//                       hintText: 'Enter your First Name',
//                     ),
//                     style: TextStyle(color: Colors.white),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your first name';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller: _lastNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Last Name',
//                       labelStyle: TextStyle(color: Colors.white),
//                       hintText: 'Enter your Last Name',
//                     ),
//                     style: TextStyle(color: Colors.white),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your last name';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       labelStyle: TextStyle(color: Colors.white),
//                       hintText: 'Enter your Email',
//                     ),
//                     style: TextStyle(color: Colors.white),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!value.contains('@')) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller: _numberController,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       labelStyle: TextStyle(color: Colors.white),
//                       hintText: 'Enter your Phone Number',
//                     ),
//                     style: TextStyle(color: Colors.white),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your phone number';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller: _qualificationController,
//                     decoration: InputDecoration(
//                       labelText: 'Highest Qualification',
//                       labelStyle: TextStyle(color: Colors.white),
//                       hintText: 'Enter your Highest Qualification',
//                     ),
//                     style: TextStyle(color: Colors.white),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your highest qualification';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _pickFile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.black,
//                     ),
//                     child: Text('Upload Highest Qualification Document'),
//                   ),
//                   if (_pickedFile != null)
//                     Text(
//                       'File Selected: ${path.basename(_pickedFile!.path)}', // Show file name
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: !_isPasswordVisible,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: TextStyle(color: Colors.white),
//                       hintText: 'Enter your Password',
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _isPasswordVisible
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _isPasswordVisible = !_isPasswordVisible;
//                           });
//                         },
//                       ),
//                     ),
//                     style: TextStyle(color: Colors.white),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate() &&
//                           _pickedFile != null) {
//                         try {
//                           // Create user with email and password
//                           final userCredential = await FirebaseAuth.instance
//                               .createUserWithEmailAndPassword(
//                             email: _emailController.text.trim(),
//                             password: _passwordController.text.trim(),
//                           );

//                           // Upload document to Firebase Storage
//                           final storageRef = FirebaseStorage.instance
//                               .ref()
//                               .child('tutor_documents')
//                               .child(userCredential.user!.uid)
//                               .child('qualification.pdf');
//                           await storageRef.putFile(_pickedFile!);
//                           final downloadUrl = await storageRef.getDownloadURL();

//                           // Add tutor data to Firestore
//                           await FirebaseFirestore.instance
//                               .collection('tutors')
//                               .doc(userCredential.user!.uid)
//                               .set({
//                             'firstName': _firstNameController.text.trim(),
//                             'lastName': _lastNameController.text.trim(),
//                             'email': _emailController.text.trim(),
//                             'number': _numberController.text.trim(),
//                             'qualification':
//                                 _qualificationController.text.trim(),
//                             'qualificationDocumentUrl': downloadUrl,
//                             'isVerified': false, // Initially set to false
//                             'availableTime': null, // Initialize as null
//                             'subjects': null, // Initialize as null
//                             'profileImageURL': null // Initialize as null
//                           });

//                           // Navigate to login page
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => LoginPage(role: 'tutor'),
//                             ),
//                           );
//                         } catch (e) {
//                           print('Error creating user: ${e.toString()}');
//                           // Show an error message to the user
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Failed to create tutor.')),
//                           );
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.black,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text('Sign Up'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart'; // Import for file picker
import 'package:path/path.dart' as path; // Import for getting file name
import 'login.dart'; // Assuming this is your login page

class TutorSignUpPage extends StatefulWidget {
  @override
  _TutorSignUpPageState createState() => _TutorSignUpPageState();
}

class _TutorSignUpPageState extends State<TutorSignUpPage> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _pickedFile; // File for the uploaded document

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    _qualificationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to pick file using file_picker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
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
        child: SingleChildScrollView(
          // Use SingleChildScrollView to allow scrolling
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'TUTOR SIGN UP',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter your First Name',
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter your Last Name',
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
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
                    controller: _numberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter your Phone Number',
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _qualificationController,
                    decoration: InputDecoration(
                      labelText: 'Highest Qualification',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter your Highest Qualification',
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your highest qualification';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Upload Highest Qualification Document'),
                  ),
                  if (_pickedFile != null)
                    Text(
                      'File Selected: ${path.basename(_pickedFile!.path)}', // Show file name
                      style: TextStyle(color: Colors.white),
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
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _pickedFile != null) {
                        try {
                          // Create user with email and password
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );

                          // Upload document to Firebase Storage
                          final storageRef = FirebaseStorage.instance
                              .ref()
                              .child('tutor_documents')
                              .child(userCredential.user!.uid)
                              .child('qualification.pdf');
                          await storageRef.putFile(_pickedFile!);
                          final downloadUrl = await storageRef.getDownloadURL();

                          // Add tutor data to Firestore
                          await FirebaseFirestore.instance
                              .collection('tutors')
                              .doc(userCredential.user!.uid)
                              .set({
                            'firstName': _firstNameController.text.trim(),
                            'lastName': _lastNameController.text.trim(),
                            'email': _emailController.text.trim(),
                            'number': _numberController.text.trim(),
                            'qualification':
                                _qualificationController.text.trim(),
                            'qualificationDocumentUrl': downloadUrl,
                            'isVerified': false, // Initially set to false
                            'availableTime': null, // Initialize as null
                            'subjects': null,
                            'classes': null, // Initialize as null
                            'profileImageURL': null // Initialize as null
                          });

                          // Navigate to login page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(role: 'tutor'),
                            ),
                          );
                        } catch (e) {
                          print('Error creating user: ${e.toString()}');
                          // Show an error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to create tutor.')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
