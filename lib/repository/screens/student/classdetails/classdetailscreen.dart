import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Classdetailscreen extends StatelessWidget {
  final Map<String, dynamic> classInfo;
  final String studentId;

  const Classdetailscreen({
    Key? key,
    required this.classInfo,
    required this.studentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classInfo['className']),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classInfo['className'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Class Code: ${classInfo['classCode']}",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 300),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Teacher: ${classInfo['teacherName']}",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 300),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Attendance Stats
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Attendance Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "Total Sessions",
                          classInfo['totalSessions'].toString(),
                          Icons.event_note,
                          Colors.blue,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          "Attended",
                          classInfo['attendedSessions'].toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  _buildStatCard(
                    "Attendance Rate",
                    "${classInfo['attendancePercentage'].toStringAsFixed(1)}%",
                    Icons.analytics,
                    classInfo['attendancePercentage'] >= 75
                        ? Colors.green
                        : classInfo['attendancePercentage'] >= 50
                        ? Colors.orange
                        : Colors.red,
                  ),
                ],
              ),
            ),

            // Attendance History
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Attendance History",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            _buildAttendanceHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        // color: color.withOpacity(0.1),
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(classInfo['teacherId'])
              .collection('Classes')
              .doc(classInfo['classId'])
              .collection('sessions')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "No sessions yet",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var sessionDoc = snapshot.data!.docs[index];
            var sessionData = sessionDoc.data() as Map<String, dynamic>;
            String sessionId = sessionDoc.id;

            return FutureBuilder<DocumentSnapshot>(
              future:
                  sessionDoc.reference
                      .collection('attendance')
                      .doc(studentId)
                      .get(),
              builder: (context, attendanceSnapshot) {
                bool isPresent =
                    attendanceSnapshot.hasData &&
                    attendanceSnapshot.data!.exists;

                Timestamp? createdAt = sessionData['createdAt'];
                String dateStr = "N/A";
                if (createdAt != null) {
                  DateTime date = createdAt.toDate();
                  dateStr =
                      "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
                }

                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            isPresent
                                ? Colors.green.withAlpha(30)
                                : Colors.red.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPresent ? Icons.check : Icons.close,
                        color: isPresent ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text("Session ${index + 1}"),
                    subtitle: Text(dateStr),
                    trailing: Chip(
                      label: Text(
                        isPresent ? "Present" : "Absent",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: isPresent ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
