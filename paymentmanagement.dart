import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPaymentManagementPage extends StatefulWidget {
  @override
  _AdminPaymentManagementPageState createState() =>
      _AdminPaymentManagementPageState();
}

class _AdminPaymentManagementPageState
    extends State<AdminPaymentManagementPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> studentsStream;
  late Stream<QuerySnapshot<Map<String, dynamic>>> tutorsStream;

  @override
  void initState() {
    super.initState();
    // Initialize streams for students and tutors collections
    studentsStream =
        FirebaseFirestore.instance.collection('students').snapshots();
    tutorsStream = FirebaseFirestore.instance.collection('tutors').snapshots();
  }

  Future<void> _addTransaction(
      String userId, bool isStudent, double amount, String type) async {
    final collection = isStudent ? 'students' : 'tutors';
    final field = isStudent ? 'balance' : 'earnings';

    final userDoc =
        FirebaseFirestore.instance.collection(collection).doc(userId);
    final userData = await userDoc.get();

    // Update balance or earnings and add a transaction
    await userDoc.update({
      field: (userData[field] ?? 0.0) + amount,
    });

    await FirebaseFirestore.instance.collection('transactions').add({
      'userId': userId,
      'amount': amount,
      'type': type,
      'timestamp': DateTime.now(),
      'isStudent': isStudent,
    });
  }

  Widget _buildUserCard(
    Map<String, dynamic> userData,
    bool isStudent,
    String userId,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${userData['firstName']} ${userData['lastName']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: ${userData['email']}'),
            Text('Phone: ${userData['number']}'),
            SizedBox(height: 8),
            Text(
              isStudent
                  ? 'Balance: \$${userData['balance']?.toStringAsFixed(2) ?? '0.00'}'
                  : 'Earnings: \$${userData['earnings']?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _addTransaction(userId, isStudent, 50.0,
                      isStudent ? 'payment' : 'withdrawal'),
                  child: Text(
                      isStudent ? 'Charge (\$50.00)' : 'Withdraw (\$50.00)'),
                ),
                ElevatedButton(
                  onPressed: () => _viewTransactions(userId, isStudent),
                  child: Text('View Transactions'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewTransactions(String userId, bool isStudent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionHistoryPage(
          userId: userId,
          isStudent: isStudent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Admin Payment Management'),
      // ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Students',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: studentsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final students = snapshot.data?.docs ?? [];
              return Column(
                children: students.map((doc) {
                  final userData = doc.data();
                  final userId = doc.id;
                  return _buildUserCard(userData, true, userId);
                }).toList(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Tutors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: tutorsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final tutors = snapshot.data?.docs ?? [];
              return Column(
                children: tutors.map((doc) {
                  final userData = doc.data();
                  final userId = doc.id;
                  return _buildUserCard(userData, false, userId);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TransactionHistoryPage extends StatelessWidget {
  final String userId;
  final bool isStudent;

  const TransactionHistoryPage(
      {Key? key, required this.userId, required this.isStudent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('userId', isEqualTo: userId)
            .where('isStudent', isEqualTo: isStudent)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data?.docs ?? [];
          if (transactions.isEmpty) {
            return Center(child: Text('No transactions found.'));
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index].data();
              return ListTile(
                title:
                    Text('${transaction['type']} - \$${transaction['amount']}'),
                subtitle: Text(transaction['timestamp'].toDate().toString()),
              );
            },
          );
        },
      ),
    );
  }
}
