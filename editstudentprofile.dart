import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class EditStudentProfilePage extends StatefulWidget {
  final String studentId;
  final VoidCallback? onRefresh;

  const EditStudentProfilePage({
    Key? key,
    required this.studentId,
    this.onRefresh,
  }) : super(key: key);

  @override
  _EditStudentProfilePageState createState() => _EditStudentProfilePageState();
}

class _EditStudentProfilePageState extends State<EditStudentProfilePage> {
  DocumentSnapshot? studentData;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  XFile? _pickedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchTutorData();
  }

  Future<void> _fetchTutorData() async {
    studentData = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .get();

    _firstNameController.text = studentData!['firstName'] ?? '';
    _lastNameController.text = studentData!['lastName'] ?? '';
    _phoneNumberController.text = studentData!['number'] ?? '';

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

  Future<String?> _uploadImageToStorage(XFile image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('students/${widget.studentId}/profile.jpg');

      await storageRef.putFile(File(image.path));
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Update the profile photo if a new one has been picked
        String? profileImageURL = _pickedImage != null
            ? await _uploadImageToStorage(_pickedImage!)
            : studentData!['profileImageUrl'];

        // Update Firestore with new data
        await FirebaseFirestore.instance
            .collection('students')
            .doc(widget.studentId)
            .update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'number': _phoneNumberController.text,
          'profileImageUrl': profileImageURL,
        });

        // Trigger onRefresh callback if provided
        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (studentData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String profileImageURL = studentData!['profileImageUrl'] ?? '';

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
                // Profile picture section
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
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Input fields
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

                SizedBox(height: 20),

                // Save button
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
