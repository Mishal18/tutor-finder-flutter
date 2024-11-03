// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart';

// class EditTutorProfilePage extends StatefulWidget {
//   final String tutorId;
//   final VoidCallback? onRefresh;
//   const EditTutorProfilePage({
//     Key? key,
//     required this.tutorId,
//     this.onRefresh,
//   }) : super(key: key);

//   @override
//   _EditTutorProfilePageState createState() => _EditTutorProfilePageState();
// }

// class _EditTutorProfilePageState extends State<EditTutorProfilePage> {
//   DocumentSnapshot? tutorData;
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _qualificationController = TextEditingController();
//   final _profileImageURLController = TextEditingController();
//   final _availableTimeController = TextEditingController();
//   XFile? _pickedImage;
//   ImagePicker _imagePicker = ImagePicker();
//   String? _selectedDay;
//   TimeOfDay? _selectedStartTime;
//   TimeOfDay? _selectedEndTime;

//   List<String> _availableDays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday'
//   ];

//   // List of subjects to choose from
//   List<String> _allSubjects = [
//     'Math',
//     'Science',
//     'English',
//     'History',
//     'Geography',
//     'Physics',
//     'Chemistry',
//     'Biology',
//     'Computer Science',
//     'Economics'
//   ];
//   List<String> _selectedSubjects = [];
//   String? _selectedSubject;

//   @override
//   void initState() {
//     super.initState();
//     _fetchTutorData();
//   }

//   Future<void> _fetchTutorData() async {
//     tutorData = await FirebaseFirestore.instance
//         .collection('tutors')
//         .doc(widget.tutorId)
//         .get();

//     _firstNameController.text = tutorData!['firstName'] ?? '';
//     _lastNameController.text = tutorData!['lastName'] ?? '';
//     _phoneNumberController.text = tutorData!['number'] ?? '';
//     _qualificationController.text = tutorData!['qualification'] ?? '';
//     _profileImageURLController.text = tutorData!['profileImageURL'] ?? '';

//     // Handle subjects as either a Map or a List
//     if (tutorData!['subjects'] is Map) {
//       Map<String, dynamic> subjectsMap = tutorData!['subjects'];
//       _selectedSubjects = subjectsMap.keys.toList();
//     } else if (tutorData!['subjects'] is List) {
//       _selectedSubjects = List<String>.from(tutorData!['subjects']);
//     } else {
//       _selectedSubjects = [];
//     }

//     setState(() {});
//   }

//   Future<void> _pickImageFromGallery() async {
//     try {
//       final pickedImage =
//           await _imagePicker.pickImage(source: ImageSource.gallery);
//       if (pickedImage != null) {
//         setState(() {
//           _pickedImage = pickedImage;
//         });
//       }
//     } catch (e) {
//       print('Error picking image: ${e.toString()}');
//     }
//   }

//   Future<void> _presentStartTimePicker() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedStartTime ?? TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _selectedStartTime = pickedTime;
//         _availableTimeController.text = _formatTimeOfDay(_selectedStartTime!) +
//             ' - ' +
//             (_selectedEndTime != null
//                 ? _formatTimeOfDay(_selectedEndTime!)
//                 : '');
//       });
//     }
//   }

//   Future<void> _presentEndTimePicker() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedEndTime ?? TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _selectedEndTime = pickedTime;
//         _availableTimeController.text = _formatTimeOfDay(_selectedStartTime!) +
//             ' - ' +
//             _formatTimeOfDay(_selectedEndTime!);
//       });
//     }
//   }

//   String _formatTimeOfDay(TimeOfDay timeOfDay) {
//     return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
//   }

//   void _addSubject() {
//     if (_selectedSubject != null &&
//         !_selectedSubjects.contains(_selectedSubject!)) {
//       setState(() {
//         _selectedSubjects.add(_selectedSubject!);
//         _selectedSubject = null; // Reset the selected subject
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (tutorData == null) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     String profileImageURL = tutorData!['profileImageURL'] ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Tutor Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Stack(
//                   alignment: Alignment.bottomRight,
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: _pickedImage != null
//                           ? FileImage(File(_pickedImage!.path))
//                           : profileImageURL.isNotEmpty
//                               ? NetworkImage(profileImageURL)
//                               : AssetImage('assets/images/avatar.png')
//                                   as ImageProvider,
//                     ),
//                     IconButton(
//                       onPressed: _pickImageFromGallery,
//                       icon: Icon(Icons.edit, color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _firstNameController,
//                   decoration: InputDecoration(labelText: 'First Name'),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your first name'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _lastNameController,
//                   decoration: InputDecoration(labelText: 'Last Name'),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your last name'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _phoneNumberController,
//                   decoration: InputDecoration(labelText: 'Phone Number'),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your phone number'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _qualificationController,
//                   decoration: InputDecoration(labelText: 'Qualification'),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your qualification'
//                       : null,
//                 ),
//                 SizedBox(height: 16),

//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(labelText: 'Available Days'),
//                   value: _selectedDay,
//                   items: _availableDays.map((day) {
//                     return DropdownMenuItem<String>(
//                       value: day,
//                       child: Text(day),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       _selectedDay = newValue;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 if (_selectedDay != null)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(_selectedDay!,
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: _presentStartTimePicker,
//                               child: AbsorbPointer(
//                                 child: TextFormField(
//                                   decoration:
//                                       InputDecoration(labelText: 'Start Time'),
//                                   enabled: false,
//                                   initialValue: _selectedStartTime != null
//                                       ? _formatTimeOfDay(_selectedStartTime!)
//                                       : null,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: _presentEndTimePicker,
//                               child: AbsorbPointer(
//                                 child: TextFormField(
//                                   decoration:
//                                       InputDecoration(labelText: 'End Time'),
//                                   enabled: false,
//                                   initialValue: _selectedEndTime != null
//                                       ? _formatTimeOfDay(_selectedEndTime!)
//                                       : null,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16),
//                     ],
//                   ),

//                 // Dropdown for selecting subjects
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(labelText: 'Select Subject'),
//                   value: _selectedSubject,
//                   items: _allSubjects.map((subject) {
//                     return DropdownMenuItem<String>(
//                       value: subject,
//                       child: Text(subject),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       _selectedSubject = newValue;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: _addSubject,
//                   child: Text('Add Subject'),
//                 ),
//                 Wrap(
//                   spacing: 8.0,
//                   children: _selectedSubjects
//                       .map((subject) => Chip(
//                             label: Text(subject),
//                             onDeleted: () {
//                               setState(() {
//                                 _selectedSubjects.remove(subject);
//                               });
//                             },
//                           ))
//                       .toList(),
//                 ),

//                 SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState?.validate() ?? false) {
//                       // Save profile
//                     }
//                   },
//                   child: Text('Save'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart';

// class EditTutorProfilePage extends StatefulWidget {
//   final String tutorId;
//   final VoidCallback? onRefresh;

//   const EditTutorProfilePage({
//     Key? key,
//     required this.tutorId,
//     this.onRefresh,
//   }) : super(key: key);

//   @override
//   _EditTutorProfilePageState createState() => _EditTutorProfilePageState();
// }

// class _EditTutorProfilePageState extends State<EditTutorProfilePage> {
//   DocumentSnapshot? tutorData;
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _qualificationController = TextEditingController();
//   final _availableTimeController = TextEditingController();
//   XFile? _pickedImage;
//   ImagePicker _imagePicker = ImagePicker();
//   String? _selectedDay;
//   TimeOfDay? _selectedStartTime;
//   TimeOfDay? _selectedEndTime;

//   List<String> _availableDays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday'
//   ];

//   // List of subjects to choose from
//   List<String> _allSubjects = [
//     'Math',
//     'Science',
//     'English',
//     'History',
//     'Geography',
//     'Physics',
//     'Chemistry',
//     'Biology',
//     'Computer Science',
//     'Economics'
//   ];
//   List<String> _selectedSubjects = [];
//   String? _selectedSubject;

//   @override
//   void initState() {
//     super.initState();
//     _fetchTutorData();
//   }

//   Future<void> _fetchTutorData() async {
//     tutorData = await FirebaseFirestore.instance
//         .collection('tutors')
//         .doc(widget.tutorId)
//         .get();

//     _firstNameController.text = tutorData!['firstName'] ?? '';
//     _lastNameController.text = tutorData!['lastName'] ?? '';
//     _phoneNumberController.text = tutorData!['number'] ?? '';
//     _qualificationController.text = tutorData!['qualification'] ?? '';

//     // Handle subjects as either a Map or a List
//     if (tutorData!['subjects'] is Map) {
//       Map<String, dynamic> subjectsMap = tutorData!['subjects'];
//       _selectedSubjects = subjectsMap.keys.toList();
//     } else if (tutorData!['subjects'] is List) {
//       _selectedSubjects = List<String>.from(tutorData!['subjects']);
//     } else {
//       _selectedSubjects = [];
//     }

//     setState(() {});
//   }

//   Future<void> _pickImageFromGallery() async {
//     try {
//       final pickedImage =
//           await _imagePicker.pickImage(source: ImageSource.gallery);
//       if (pickedImage != null) {
//         setState(() {
//           _pickedImage = pickedImage;
//         });
//       }
//     } catch (e) {
//       print('Error picking image: ${e.toString()}');
//     }
//   }

//   Future<void> _presentStartTimePicker() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedStartTime ?? TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _selectedStartTime = pickedTime;
//         _availableTimeController.text = _formatTimeOfDay(_selectedStartTime!) +
//             ' - ' +
//             (_selectedEndTime != null
//                 ? _formatTimeOfDay(_selectedEndTime!)
//                 : '');
//       });
//     }
//   }

//   Future<void> _presentEndTimePicker() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedEndTime ?? TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _selectedEndTime = pickedTime;
//         _availableTimeController.text = _formatTimeOfDay(_selectedStartTime!) +
//             ' - ' +
//             _formatTimeOfDay(_selectedEndTime!);
//       });
//     }
//   }

//   String _formatTimeOfDay(TimeOfDay timeOfDay) {
//     return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
//   }

//   void _addSubject() {
//     if (_selectedSubject != null &&
//         !_selectedSubjects.contains(_selectedSubject!)) {
//       setState(() {
//         _selectedSubjects.add(_selectedSubject!);
//         _selectedSubject = null; // Reset the selected subject
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         // Create a map of the tutor's profile data
//         Map<String, dynamic> tutorData = {
//           'firstName': _firstNameController.text,
//           'lastName': _lastNameController.text,
//           'number': _phoneNumberController.text,
//           'qualification': _qualificationController.text,
//           'profileImageURL': _pickedImage != null
//               ? await _uploadImageToStorage(_pickedImage!)
//               : null,
//           'availableDays': _selectedDay,
//           'availableTime': {
//             'start': _selectedStartTime != null
//                 ? _formatTimeOfDay(_selectedStartTime!)
//                 : null,
//             'end': _selectedEndTime != null
//                 ? _formatTimeOfDay(_selectedEndTime!)
//                 : null,
//           },
//           'subjects': _selectedSubjects, // Save subjects as an array
//         };

//         // Save the data to Firestore
//         await FirebaseFirestore.instance
//             .collection('tutors')
//             .doc(widget.tutorId)
//             .update(tutorData);

//         // Call the onRefresh callback if provided
//         if (widget.onRefresh != null) {
//           widget.onRefresh!();
//         }

//         // Optionally show a success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile updated successfully')),
//         );

//         // Navigate back or close the form
//         Navigator.pop(context);
//       } catch (e) {
//         print('Error saving profile: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update profile')),
//         );
//       }
//     }
//   }

//   Future<String?> _uploadImageToStorage(XFile image) async {
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('tutors/${widget.tutorId}/profile.jpg');

//       await storageRef.putFile(File(image.path));
//       String downloadURL = await storageRef.getDownloadURL();
//       return downloadURL;
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (tutorData == null) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     String profileImageURL = tutorData!['profileImageURL'] ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Tutor Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Stack(
//                   alignment: Alignment.bottomRight,
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: _pickedImage != null
//                           ? FileImage(File(_pickedImage!.path))
//                           : profileImageURL.isNotEmpty
//                               ? NetworkImage(profileImageURL)
//                               : AssetImage('assets/images/avatar.png')
//                                   as ImageProvider,
//                     ),
//                     IconButton(
//                       onPressed: _pickImageFromGallery,
//                       icon: Icon(Icons.edit, color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _firstNameController,
//                   decoration: InputDecoration(labelText: 'First Name'),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your first name'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _lastNameController,
//                   decoration: InputDecoration(labelText: 'Last Name'),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your last name'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _phoneNumberController,
//                   decoration: InputDecoration(labelText: 'Phone Number'),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your phone number'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _qualificationController,
//                   decoration: InputDecoration(labelText: 'Qualification'),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your qualification'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedDay,
//                   hint: Text('Select Available Day'),
//                   items: _availableDays
//                       .map((day) => DropdownMenuItem<String>(
//                             value: day,
//                             child: Text(day),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedDay = value;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Please select a day' : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   readOnly: true,
//                   controller: _availableTimeController,
//                   decoration: InputDecoration(labelText: 'Available Time'),
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text('Select Time'),
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               TextButton(
//                                 onPressed: _presentStartTimePicker,
//                                 child: Text('Select Start Time'),
//                               ),
//                               TextButton(
//                                 onPressed: _presentEndTimePicker,
//                                 child: Text('Select End Time'),
//                               ),
//                             ],
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: Text('Done'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedSubject,
//                   hint: Text('Select Subject'),
//                   items: _allSubjects
//                       .map((subject) => DropdownMenuItem<String>(
//                             value: subject,
//                             child: Text(subject),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedSubject = value;
//                     });
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: _addSubject,
//                   child: Text('Add Subject'),
//                 ),
//                 Wrap(
//                   spacing: 8.0,
//                   children: _selectedSubjects
//                       .map((subject) => Chip(
//                             label: Text(subject),
//                             deleteIcon: Icon(Icons.close),
//                             onDeleted: () {
//                               setState(() {
//                                 _selectedSubjects.remove(subject);
//                               });
//                             },
//                           ))
//                       .toList(),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _saveProfile,
//                   child: Text('Save'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart';

// class EditTutorProfilePage extends StatefulWidget {
//   final String tutorId;
//   final VoidCallback? onRefresh;

//   const EditTutorProfilePage({
//     Key? key,
//     required this.tutorId,
//     this.onRefresh,
//   }) : super(key: key);

//   @override
//   _EditTutorProfilePageState createState() => _EditTutorProfilePageState();
// }

// class _EditTutorProfilePageState extends State<EditTutorProfilePage> {
//   DocumentSnapshot? tutorData;
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _qualificationController = TextEditingController();
//   final _availableTimeController = TextEditingController();
//   XFile? _pickedImage;
//   ImagePicker _imagePicker = ImagePicker();
//   String? _selectedDay;
//   TimeOfDay? _selectedStartTime;
//   TimeOfDay? _selectedEndTime;

//   List<String> _availableDays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday'
//   ];

//   // List of subjects to choose from
//   List<String> _allSubjects = [
//     'Math',
//     'Science',
//     'English',
//     'History',
//     'Geography',
//     'Physics',
//     'Chemistry',
//     'Biology',
//     'Computer Science',
//     'Economics'
//   ];
//   List<String> _selectedSubjects = [];
//   String? _selectedSubject;

//   // List of classes from 1 to 12
//   List<String> _allClasses =
//       List.generate(12, (index) => (index + 1).toString());
//   List<String> _selectedClasses = [];
//   String? _selectedClass;

//   @override
//   void initState() {
//     super.initState();
//     _fetchTutorData();
//   }

//   Future<void> _fetchTutorData() async {
//     tutorData = await FirebaseFirestore.instance
//         .collection('tutors')
//         .doc(widget.tutorId)
//         .get();

//     _firstNameController.text = tutorData!['firstName'] ?? '';
//     _lastNameController.text = tutorData!['lastName'] ?? '';
//     _phoneNumberController.text = tutorData!['number'] ?? '';
//     _qualificationController.text = tutorData!['qualification'] ?? '';

//     // Handle subjects as either a Map or a List
//     if (tutorData!['subjects'] is Map) {
//       Map<String, dynamic> subjectsMap = tutorData!['subjects'];
//       _selectedSubjects = subjectsMap.keys.toList();
//     } else if (tutorData!['subjects'] is List) {
//       _selectedSubjects = List<String>.from(tutorData!['subjects']);
//     } else {
//       _selectedSubjects = [];
//     }

//     // Handle classes similarly
//     if (tutorData!['classes'] is List) {
//       _selectedClasses = List<String>.from(tutorData!['classes']);
//     } else {
//       _selectedClasses =
//           []; // Set to an empty list if 'classes' field is missing
//     }

//     setState(() {});
//   }

//   Future<void> _pickImageFromGallery() async {
//     try {
//       final pickedImage =
//           await _imagePicker.pickImage(source: ImageSource.gallery);
//       if (pickedImage != null) {
//         setState(() {
//           _pickedImage = pickedImage;
//         });
//       }
//     } catch (e) {
//       print('Error picking image: ${e.toString()}');
//     }
//   }

//   Future<void> _presentStartTimePicker() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedStartTime ?? TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _selectedStartTime = pickedTime;
//         _availableTimeController.text = _formatTimeOfDay(_selectedStartTime!) +
//             ' - ' +
//             (_selectedEndTime != null
//                 ? _formatTimeOfDay(_selectedEndTime!)
//                 : '');
//       });
//     }
//   }

//   Future<void> _presentEndTimePicker() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedEndTime ?? TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _selectedEndTime = pickedTime;
//         _availableTimeController.text = _formatTimeOfDay(_selectedStartTime!) +
//             ' - ' +
//             _formatTimeOfDay(_selectedEndTime!);
//       });
//     }
//   }

//   String _formatTimeOfDay(TimeOfDay timeOfDay) {
//     return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
//   }

//   void _addSubject() {
//     if (_selectedSubject != null &&
//         !_selectedSubjects.contains(_selectedSubject!)) {
//       setState(() {
//         _selectedSubjects.add(_selectedSubject!);
//         _selectedSubject = null; // Reset the selected subject
//       });
//     }
//   }

//   void _addClass() {
//     if (_selectedClass != null && !_selectedClasses.contains(_selectedClass!)) {
//       setState(() {
//         _selectedClasses.add(_selectedClass!);
//         _selectedClass = null; // Reset the selected class
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         // Create a map of the tutor's profile data
//         Map<String, dynamic> tutorData = {
//           'firstName': _firstNameController.text,
//           'lastName': _lastNameController.text,
//           'number': _phoneNumberController.text,
//           'qualification': _qualificationController.text,
//           'profileImageURL': _pickedImage != null
//               ? await _uploadImageToStorage(_pickedImage!)
//               : null,
//           'availableDays': _selectedDay,
//           'availableTime': {
//             'start': _selectedStartTime != null
//                 ? _formatTimeOfDay(_selectedStartTime!)
//                 : null,
//             'end': _selectedEndTime != null
//                 ? _formatTimeOfDay(_selectedEndTime!)
//                 : null,
//           },
//           'subjects': _selectedSubjects, // Save subjects as an array
//           'classes': _selectedClasses, // Save selected classes
//         };

//         // Save the data to Firestore
//         await FirebaseFirestore.instance
//             .collection('tutors')
//             .doc(widget.tutorId)
//             .update(tutorData);

//         // Call the onRefresh callback if provided
//         if (widget.onRefresh != null) {
//           widget.onRefresh!();
//         }

//         // Optionally show a success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile updated successfully')),
//         );

//         // Navigate back or close the form
//         Navigator.pop(context);
//       } catch (e) {
//         print('Error saving profile: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update profile')),
//         );
//       }
//     }
//   }

//   Future<String?> _uploadImageToStorage(XFile image) async {
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('tutors/${widget.tutorId}/profile.jpg');

//       await storageRef.putFile(File(image.path));
//       String downloadURL = await storageRef.getDownloadURL();
//       return downloadURL;
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (tutorData == null) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     String profileImageURL = tutorData!['profileImageURL'] ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Tutor Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Stack(
//                   alignment: Alignment.bottomRight,
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: _pickedImage != null
//                           ? FileImage(File(_pickedImage!.path))
//                           : profileImageURL.isNotEmpty
//                               ? NetworkImage(profileImageURL)
//                               : AssetImage('assets/images/avatar.png')
//                                   as ImageProvider,
//                     ),
//                     IconButton(
//                       onPressed: _pickImageFromGallery,
//                       icon: Icon(Icons.edit, color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _firstNameController,
//                   decoration: InputDecoration(labelText: 'First Name'),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your first name'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _lastNameController,
//                   decoration: InputDecoration(labelText: 'Last Name'),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your last name'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _phoneNumberController,
//                   decoration: InputDecoration(labelText: 'Phone Number'),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your phone number'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _qualificationController,
//                   decoration: InputDecoration(labelText: 'Qualification'),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter your qualification'
//                       : null,
//                 ),
//                 SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedDay,
//                   hint: Text('Select Available Day'),
//                   items: _availableDays
//                       .map((day) => DropdownMenuItem<String>(
//                             value: day,
//                             child: Text(day),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedDay = value;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Please select a day' : null,
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   readOnly: true,
//                   controller: _availableTimeController,
//                   decoration: InputDecoration(labelText: 'Available Time'),
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text('Select Time'),
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               TextButton(
//                                 onPressed: _presentStartTimePicker,
//                                 child: Text('Select Start Time'),
//                               ),
//                               TextButton(
//                                 onPressed: _presentEndTimePicker,
//                                 child: Text('Select End Time'),
//                               ),
//                             ],
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: Text('Done'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedSubject,
//                   hint: Text('Select Subject'),
//                   items: _allSubjects
//                       .map((subject) => DropdownMenuItem<String>(
//                             value: subject,
//                             child: Text(subject),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedSubject = value;
//                     });
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: _addSubject,
//                   child: Text('Add Subject'),
//                 ),
//                 Wrap(
//                   spacing: 8.0,
//                   children: _selectedSubjects
//                       .map((subject) => Chip(
//                             label: Text(subject),
//                             deleteIcon: Icon(Icons.close),
//                             onDeleted: () {
//                               setState(() {
//                                 _selectedSubjects.remove(subject);
//                               });
//                             },
//                           ))
//                       .toList(),
//                 ),
//                 SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedClass,
//                   hint: Text('Select Class'),
//                   items: _allClasses
//                       .map((classNum) => DropdownMenuItem<String>(
//                             value: classNum,
//                             child: Text('Class $classNum'),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedClass = value;
//                     });
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: _addClass,
//                   child: Text('Add Class'),
//                 ),
//                 Wrap(
//                   spacing: 8.0,
//                   children: _selectedClasses
//                       .map((classNum) => Chip(
//                             label: Text('Class $classNum'),
//                             deleteIcon: Icon(Icons.close),
//                             onDeleted: () {
//                               setState(() {
//                                 _selectedClasses.remove(classNum);
//                               });
//                             },
//                           ))
//                       .toList(),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _saveProfile,
//                   child: Text('Save'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class EditTutorProfilePage extends StatefulWidget {
  final String tutorId;
  final VoidCallback? onRefresh;

  const EditTutorProfilePage({
    Key? key,
    required this.tutorId,
    this.onRefresh,
  }) : super(key: key);

  @override
  _EditTutorProfilePageState createState() => _EditTutorProfilePageState();
}

class _EditTutorProfilePageState extends State<EditTutorProfilePage> {
  DocumentSnapshot? tutorData;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _qualificationController = TextEditingController();
  XFile? _pickedImage;
  ImagePicker _imagePicker = ImagePicker();

  List<DateTime> _selectedDates = [];
  Map<DateTime, TimeRange> _availableTimes = {};

  List<String> _allSubjects = [
    'Math',
    'Science',
    'English',
    'History',
    'Geography',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science',
    'Economics'
  ];
  List<String> _selectedSubjects = [];
  String? _selectedSubject;

  List<String> _allClasses =
      List.generate(12, (index) => (index + 1).toString());
  List<String> _selectedClasses = [];
  String? _selectedClass;

  @override
  void initState() {
    super.initState();
    _fetchTutorData();
  }

  Future<void> _fetchTutorData() async {
    tutorData = await FirebaseFirestore.instance
        .collection('tutors')
        .doc(widget.tutorId)
        .get();

    _firstNameController.text = tutorData!['firstName'] ?? '';
    _lastNameController.text = tutorData!['lastName'] ?? '';
    _phoneNumberController.text = tutorData!['number'] ?? '';
    _qualificationController.text = tutorData!['qualification'] ?? '';

    // Handle subjects
    if (tutorData!['subjects'] is List) {
      _selectedSubjects = List<String>.from(tutorData!['subjects']);
    } else {
      _selectedSubjects = [];
    }

    // Handle classes
    if (tutorData!['classes'] is List) {
      _selectedClasses = List<String>.from(tutorData!['classes']);
    } else {
      _selectedClasses = [];
    }

    // Handle available dates and times
    if (tutorData!['availableDays'] is List) {
      var availableDays =
          List<Map<String, dynamic>>.from(tutorData!['availableDays']);
      for (var day in availableDays) {
        DateTime date = (day['date'] as Timestamp).toDate();
        TimeRange times = TimeRange(
            start: day['availableTime']['start'],
            end: day['availableTime']['end']);
        _selectedDates.add(date);
        _availableTimes[date] = times;
      }
    }

    setState(() {});
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedImage =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _pickedImage = pickedImage;
        });
      }
    } catch (e) {
      print('Error picking image: ${e.toString()}');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && !_selectedDates.contains(selectedDate)) {
      _selectedDates.add(selectedDate);
      setState(() {});
      _selectTimeForDate(selectedDate);
    }
  }

  Future<void> _selectTimeForDate(DateTime date) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (startTime != null && endTime != null) {
      _availableTimes[date] = TimeRange(
        start: _formatTimeOfDay(startTime),
        end: _formatTimeOfDay(endTime),
      );
      setState(() {});
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  void _addSubject() {
    if (_selectedSubject != null &&
        !_selectedSubjects.contains(_selectedSubject!)) {
      setState(() {
        _selectedSubjects.add(_selectedSubject!);
        _selectedSubject = null; // Reset the selected subject
      });
    }
  }

  void _addClass() {
    if (_selectedClass != null && !_selectedClasses.contains(_selectedClass!)) {
      setState(() {
        _selectedClasses.add(_selectedClass!);
        _selectedClass = null; // Reset the selected class
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create a map of the tutor's profile data
        Map<String, dynamic> tutorData = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'number': _phoneNumberController.text,
          'qualification': _qualificationController.text,
          'profileImageURL': _pickedImage != null
              ? await _uploadImageToStorage(_pickedImage!)
              : null,
          'availableDays': _selectedDates.map((date) {
            return {
              'date': Timestamp.fromDate(date),
              'availableTime': {
                'start': _availableTimes[date]?.start,
                'end': _availableTimes[date]?.end,
              }
            };
          }).toList(),
          'subjects': _selectedSubjects,
          'classes': _selectedClasses,
        };

        // Save the data to Firestore
        await FirebaseFirestore.instance
            .collection('tutors')
            .doc(widget.tutorId)
            .update(tutorData);

        // Call the onRefresh callback if provided
        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }

        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        // Navigate back or close the form
        Navigator.pop(context);
      } catch (e) {
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  Future<String?> _uploadImageToStorage(XFile image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('tutors/${widget.tutorId}/profile.jpg');

      await storageRef.putFile(File(image.path));
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tutorData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String profileImageURL = tutorData!['profileImageURL'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tutor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _pickedImage != null
                          ? FileImage(File(_pickedImage!.path))
                          : profileImageURL.isNotEmpty
                              ? NetworkImage(profileImageURL)
                              : AssetImage('assets/images/avatar.png')
                                  as ImageProvider,
                    ),
                    IconButton(
                      onPressed: _pickImageFromGallery,
                      icon: Icon(Icons.edit, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your first name'
                      : null,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your last name'
                      : null,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your phone number'
                      : null,
                ),
                TextFormField(
                  controller: _qualificationController,
                  decoration: InputDecoration(labelText: 'Qualification'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your qualification'
                      : null,
                ),
                SizedBox(height: 20),
                Text('Available Dates:', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: Text('Add Date'),
                ),
                ..._selectedDates.map((date) {
                  return ListTile(
                    title: Text(DateFormat.yMd().format(date)),
                    subtitle: Text(
                      'Time: ${_availableTimes[date]?.start ?? ''} - ${_availableTimes[date]?.end ?? ''}',
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
                Text('Subjects:', style: TextStyle(fontSize: 16)),
                // Display selected subjects and the option to add more
                Wrap(
                  spacing: 8,
                  children: _selectedSubjects
                      .map((subject) => Chip(
                            label: Text(subject),
                            onDeleted: () {
                              setState(() {
                                _selectedSubjects.remove(subject);
                              });
                            },
                          ))
                      .toList(),
                ),
                DropdownButton<String>(
                  value: _selectedSubject,
                  hint: Text('Select Subject'),
                  items: _allSubjects
                      .map((subject) => DropdownMenuItem(
                            value: subject,
                            child: Text(subject),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubject = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _addSubject,
                  child: Text('Add Subject'),
                ),
                SizedBox(height: 20),
                Text('Classes:', style: TextStyle(fontSize: 16)),
                // Display selected classes and the option to add more
                Wrap(
                  spacing: 8,
                  children: _selectedClasses
                      .map((className) => Chip(
                            label: Text(className),
                            onDeleted: () {
                              setState(() {
                                _selectedClasses.remove(className);
                              });
                            },
                          ))
                      .toList(),
                ),
                DropdownButton<String>(
                  value: _selectedClass,
                  hint: Text('Select Class'),
                  items: _allClasses
                      .map((className) => DropdownMenuItem(
                            value: className,
                            child: Text(className),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClass = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _addClass,
                  child: Text('Add Class'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Save Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeRange {
  final String start;
  final String end;

  TimeRange({required this.start, required this.end});
}
