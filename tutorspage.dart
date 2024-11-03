import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tutorprofile.dart';

class TutorsPage extends StatefulWidget {
  const TutorsPage({Key? key}) : super(key: key);

  @override
  _TutorsPageState createState() => _TutorsPageState();
}

class _TutorsPageState extends State<TutorsPage> {
  final _searchController = TextEditingController();
  List<String> _selectedSubjects = [];
  List<String> _selectedClasses = [];
  List<DocumentSnapshot> _tutors = []; // Store all tutors
  List<DocumentSnapshot> _filteredTutors = []; // Store filtered tutors
  List<String> _availableSubjects = [];
  List<String> _availableClasses = [];

  @override
  void initState() {
    super.initState();
    _fetchTutors();
  }

  Future<void> _fetchTutors() async {
    final QuerySnapshot tutorsSnapshot =
        await FirebaseFirestore.instance.collection('tutors').get();
    _tutors = tutorsSnapshot.docs;
    _filteredTutors = List.from(_tutors); // Initially display all tutors
    _extractAvailableSubjectsAndClasses(); // Populate subjects and classes
    await _filterTutorsWithAvailableSlots(); // Filter tutors based on available slots
    setState(() {});
  }

  Future<void> _filterTutorsWithAvailableSlots() async {
    final List<DocumentSnapshot> availableTutors = [];

    for (var tutor in _tutors) {
      final data =
          tutor.data() as Map<String, dynamic>?; // Cast to nullable Map
      if (data != null && data.containsKey('availableDays')) {
        final availableDays = data['availableDays'];

        if (availableDays is List) {
          // Check for available time slots that are not booked
          bool hasAvailableTimeSlots = false;

          for (var dayMap in availableDays) {
            if (dayMap is Map<String, dynamic>) {
              final date = dayMap['date'];
              final availableTime = dayMap['availableTime'];

              // Check for scheduled classes
              if (availableTime is Map<String, dynamic>) {
                final startTime = availableTime['start'] ?? 'N/A';
                final endTime = availableTime['end'] ?? 'N/A';

                final bookedClassesSnapshot = await FirebaseFirestore.instance
                    .collection('scheduledClasses')
                    .where('tutorId', isEqualTo: tutor.id)
                    .where('date', isEqualTo: date)
                    .where('startTime', isEqualTo: startTime)
                    .where('endTime', isEqualTo: endTime)
                    .get();

                // If no classes are booked during this time slot, we have an available slot
                if (bookedClassesSnapshot.docs.isEmpty) {
                  hasAvailableTimeSlots = true;
                  break; // No need to check further if at least one slot is available
                }
              }
            }
          }

          // Add the tutor to the available list if they have at least one available time slot
          if (hasAvailableTimeSlots) {
            availableTutors.add(tutor);
          }
        }
      }
    }

    _filteredTutors = availableTutors; // Update filtered tutors list
  }

  void _extractAvailableSubjectsAndClasses() {
    Set<String> subjectsSet = {};
    Set<String> classesSet = {};

    for (var tutor in _tutors) {
      final data =
          tutor.data() as Map<String, dynamic>?; // Cast to nullable Map

      // Check if 'subjects' exists
      if (data != null && data.containsKey('subjects')) {
        final subjectsData = data['subjects'];
        if (subjectsData != null) {
          if (subjectsData is List) {
            subjectsSet.addAll(subjectsData.cast<String>());
          } else if (subjectsData is String) {
            subjectsSet.add(subjectsData);
          }
        }
      }

      // Check if 'classes' exists
      if (data != null && data.containsKey('classes')) {
        final classesData = data['classes'];
        if (classesData != null) {
          if (classesData is List) {
            classesSet.addAll(classesData.cast<String>());
          } else if (classesData is String) {
            classesSet.add(classesData);
          }
        }
      }
    }

    _availableSubjects = subjectsSet.toList();
    _availableClasses = classesSet.toList();
  }

  void _filterTutors() {
    String searchText = _searchController.text.toLowerCase();

    setState(() {
      _filteredTutors = _tutors.where((tutor) {
        final data =
            tutor.data() as Map<String, dynamic>?; // Cast to nullable Map
        final firstName = data?['firstName']?.toLowerCase() ?? '';
        final lastName = data?['lastName']?.toLowerCase() ?? '';

        // Check if search text matches either first or last name
        bool matchesName =
            firstName.contains(searchText) || lastName.contains(searchText);

        // Subjects and classes filtering logic remains
        bool matchesSubjects = _selectedSubjects.isEmpty ||
            (data != null &&
                data.containsKey('subjects') &&
                (data['subjects'] is List &&
                    (_selectedSubjects
                            .toSet()
                            .intersection((data['subjects'] as List).toSet()))
                        .isNotEmpty));

        bool matchesClasses = _selectedClasses.isEmpty ||
            (data != null &&
                data.containsKey('classes') &&
                (data['classes'] is List &&
                    (_selectedClasses
                            .toSet()
                            .intersection((data['classes'] as List).toSet()))
                        .isNotEmpty));

        return matchesName && matchesSubjects && matchesClasses;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        title: Text('Available Tutors'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _searchController,
                          decoration:
                              InputDecoration(labelText: 'Search Tutors'),
                          onChanged: (value) =>
                              _filterTutors(), // Update filter on change
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _filterTutors(); // Filter after closing the modal
                          },
                          child: Text('Search'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Filter by Subjects and Classes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 16),
                        // Subject Filter
                        Wrap(
                          children: _availableSubjects.map((subject) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FilterChip(
                                label: Text(subject),
                                selected: _selectedSubjects.contains(subject),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedSubjects.add(subject);
                                    } else {
                                      _selectedSubjects.remove(subject);
                                    }
                                  });
                                  _filterTutors();
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16),
                        // Class Filter
                        Wrap(
                          children: _availableClasses.map((classNum) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FilterChip(
                                label: Text(classNum),
                                selected: _selectedClasses.contains(classNum),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedClasses.add(classNum);
                                    } else {
                                      _selectedClasses.remove(classNum);
                                    }
                                  });
                                  _filterTutors();
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _filteredTutors.isEmpty
          ? Center(
              child: Text(
                  'No tutors found with available time slots. Please adjust your search or filter options.'))
          : ListView.builder(
              itemCount: _filteredTutors.length,
              itemBuilder: (context, index) {
                final tutor = _filteredTutors[index];
                final tutorId = tutor.id;
                final data = tutor.data()
                    as Map<String, dynamic>?; // Cast to nullable Map
                final firstName = data?['firstName'] ?? '';
                final lastName = data?['lastName'] ?? '';
                final subjects = (data != null &&
                        data.containsKey('subjects') &&
                        (data['subjects'] is List))
                    ? (data['subjects'] as List).join(', ')
                    : '';
                final classes = (data != null &&
                        data.containsKey('classes') &&
                        (data['classes'] is List))
                    ? (data['classes'] as List).join(', ')
                    : '';
                String availableDatesString = '';
                if (data != null && data.containsKey('availableDays')) {
                  final availableDays = data['availableDays'];

                  // Check if availableDays is a List
                  if (availableDays is List) {
                    availableDatesString = availableDays.map((dayMap) {
                      if (dayMap is Map<String, dynamic>) {
                        // Safely access the date and availableTime
                        final date = dayMap['date'];
                        final availableTime = dayMap['availableTime'];

                        String formattedDate = '';
                        if (date is String) {
                          formattedDate = date; // Or parse if necessary
                        } else if (date is Timestamp) {
                          formattedDate =
                              DateFormat('yMMMd').format(date.toDate());
                        }

                        // Check if availableTime is a Map
                        if (availableTime is Map<String, dynamic>) {
                          final startTime = availableTime['start'] ?? 'N/A';
                          final endTime = availableTime['end'] ?? 'N/A';
                          return '$formattedDate: $startTime - $endTime';
                        }
                      }
                      return ''; // In case of unexpected format
                    }).join('\n'); // Join dates and times by new line
                  }
                }
                return Card(
                  margin: EdgeInsets.symmetric(
                      vertical: 4, horizontal: 16), // Reduced vertical margin
                  child: Padding(
                    padding:
                        const EdgeInsets.all(8.0), // Adjust padding as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$firstName $lastName',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                            height:
                                4), // Add some space between the name and other info
                        Text('Subjects: $subjects'),
                        Text('Classes: $classes'),
                        Text(
                            'Available Dates and Times:\n$availableDatesString'),
                        SizedBox(height: 8), // Add space before the button row
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween, // Align buttons
                          children: [
                            TextButton(
                              child: Text('View Profile'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TutorProfilePage(
                                      tutorId: tutorId,
                                      userRole: 'student',
                                    ),
                                  ),
                                );
                              },
                            ),
                            TextButton(
                              child: Text('Message Tutor'),
                              onPressed: () {
                                // Implement messaging functionality
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
