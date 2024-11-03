import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing/screens/tutorprofile.dart';
import 'tutordashboard.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // Firebase references
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // List to hold the tutor's chat conversations
  List<Map<String, dynamic>> _chatConversations = [];

  // List to hold the tutor's student details (for displaying names)
  List<Map<String, dynamic>> _studentDetails = [];

  // Function to fetch the tutor's chat conversations
  Future<void> _fetchChatConversations() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('chats')
          .where('tutorId', isEqualTo: user.uid)
          .get();
      setState(() async {
        _chatConversations = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        _studentDetails = [];
        for (var chatData in _chatConversations) {
          final studentId = chatData['studentId'];
          final studentDoc =
              await _firestore.collection('students').doc(studentId).get();
          if (studentDoc.exists) {
            _studentDetails.add(studentDoc.data()!);
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchChatConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the list of chat conversations
            Expanded(
              child: ListView.builder(
                itemCount: _chatConversations.length,
                itemBuilder: (context, index) {
                  final chatData = _chatConversations[index];
                  // Get the corresponding student details
                  final studentData = _studentDetails[index];
                  // Display the chat details
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: studentData['profileImageUrl'] != null
                            ? NetworkImage(studentData['profileImageUrl']!)
                            : null,
                        backgroundColor: Colors.blue,
                        child: studentData['profileImageUrl'] == null
                            ? Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      title: Text(
                        '${studentData['firstName']} ${studentData['lastName']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        '${chatData['lastMessage']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        // Navigate to a chat screen (implement this logic)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              studentId: studentData[
                                  'studentId'], // Pass the student ID
                              tutorId:
                                  _auth.currentUser!.uid, // Pass the tutor ID
                              studentName:
                                  '${studentData['firstName']} ${studentData['lastName']}', // Pass the student name
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chat Screen Widget
class ChatScreen extends StatefulWidget {
  final String studentId;
  final String tutorId;
  final String studentName;

  const ChatScreen(
      {Key? key,
      required this.studentId,
      required this.tutorId,
      required this.studentName})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _messages = [];

  // Function to fetch chat messages
  Future<void> _fetchMessages() async {
    final snapshot = await _firestore
        .collection('chats')
        .doc(
            '${widget.studentId}-${widget.tutorId}') // Document ID based on student ID and tutor ID
        .collection('messages') // Subcollection for messages
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      _messages = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  // Function to send a new message
  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Store the message in Firestore
      await _firestore
          .collection('chats')
          .doc('${widget.studentId}-${widget.tutorId}')
          .collection('messages')
          .add({
        'senderId': _auth.currentUser!.uid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false // Default to not read
      });
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc('${widget.studentId}-${widget.tutorId}')
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData = messages[index];
                      return _buildMessage(messageData);
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build each chat message
  Widget _buildMessage(Map<String, dynamic> messageData) {
    bool isCurrentUser = messageData['senderId'] == _auth.currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Show the user's profile image or a default avatar
          if (messageData['senderId'] == widget.studentId)
            CircleAvatar(
              backgroundImage: messageData['profileImageUrl'] != null
                  ? NetworkImage(messageData['profileImageUrl']!)
                  : AssetImage('assets/images/avatar.png') as ImageProvider,
            ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  messageData['message'],
                  style: TextStyle(
                    fontSize: 16,
                    color: isCurrentUser ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                // Display "Read" if the message is read
                if (isCurrentUser && messageData['isRead'])
                  Text(
                    'Read',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
