import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherAnalytics extends StatefulWidget {
  const TeacherAnalytics({Key? key}) : super(key: key);

  @override
  State<TeacherAnalytics> createState() => _TeacherAnalyticsState();
}

class _TeacherAnalyticsState extends State<TeacherAnalytics> {
  String teacherId = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>> getAnalyticsData() async {
    try {
      // Get all classes for this teacher
      QuerySnapshot classesSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(teacherId)
              .collection('Classes')
              .get();

      int totalClasses = classesSnapshot.docs.length;
      int totalStudents = 0;
      int totalSessions = 0;
      int totalAttendanceRecords = 0;
      List<Map<String, dynamic>> classDetails = [];

      for (var classDoc in classesSnapshot.docs) {
        Map<String, dynamic> classData =
            classDoc.data() as Map<String, dynamic>;
        String classId = classDoc.id;

        // Get enrolled students
        QuerySnapshot studentsSnapshot =
            await classDoc.reference.collection('enrolledStudents').get();
        int enrolledStudents = studentsSnapshot.docs.length;
        totalStudents += enrolledStudents;

        // Get sessions
        QuerySnapshot sessionsSnapshot =
            await classDoc.reference.collection('sessions').get();
        int classSessions = sessionsSnapshot.docs.length;
        totalSessions += classSessions;

        // Calculate attendance for this class
        int classAttendanceCount = 0;
        List<Map<String, dynamic>> studentAttendanceList = [];

        for (var studentDoc in studentsSnapshot.docs) {
          Map<String, dynamic> studentData =
              studentDoc.data() as Map<String, dynamic>;
          String studentId = studentDoc.id;
          int studentAttended = 0;

          // Count how many sessions this student attended
          for (var sessionDoc in sessionsSnapshot.docs) {
            DocumentSnapshot attendanceDoc =
                await sessionDoc.reference
                    .collection('attendance')
                    .doc(studentId)
                    .get();
            if (attendanceDoc.exists) {
              studentAttended++;
              classAttendanceCount++;
            }
          }

          double studentPercentage =
              classSessions > 0 ? (studentAttended / classSessions) * 100 : 0;

          studentAttendanceList.add({
            'studentName': studentData['studentName'] ?? 'Unknown',
            'attended': studentAttended,
            'total': classSessions,
            'percentage': studentPercentage,
          });
        }

        // Sort students by percentage (lowest first for at-risk identification)
        studentAttendanceList.sort(
          (a, b) => a['percentage'].compareTo(b['percentage']),
        );

        totalAttendanceRecords += classAttendanceCount;

        double classAvgAttendance =
            (enrolledStudents > 0 && classSessions > 0)
                ? (classAttendanceCount / (enrolledStudents * classSessions)) *
                    100
                : 0;

        classDetails.add({
          'classId': classId,
          'className': classData['className'] ?? 'Unknown',
          'classCode': classData['classCode'] ?? 'N/A',
          'enrolledStudents': enrolledStudents,
          'sessions': classSessions,
          'avgAttendance': classAvgAttendance,
          'studentsList': studentAttendanceList,
        });
      }

      // Calculate overall average attendance
      double overallAvgAttendance =
          (totalStudents > 0 && totalSessions > 0)
              ? (totalAttendanceRecords / (totalStudents * totalSessions)) * 100
              : 0;

      return {
        'totalClasses': totalClasses,
        'totalStudents': totalStudents,
        'totalSessions': totalSessions,
        'overallAvgAttendance': overallAvgAttendance,
        'classDetails': classDetails,
      };
    } catch (e) {
      print('Error getting analytics: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getAnalyticsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error loading analytics',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          var data = snapshot.data!;
          List<Map<String, dynamic>> classDetails =
              data['classDetails'] as List<Map<String, dynamic>>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Stats Section
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
                        'Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Classes',
                              '${data['totalClasses']}',
                              Icons.class_,
                              Colors.blue,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: _buildOverviewCard(
                              'Students',
                              '${data['totalStudents']}',
                              Icons.people,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Sessions',
                              '${data['totalSessions']}',
                              Icons.event_note,
                              Colors.orange,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: _buildOverviewCard(
                              'Avg Attendance',
                              '${data['overallAvgAttendance'].toStringAsFixed(1)}%',
                              Icons.analytics,
                              data['overallAvgAttendance'] >= 75
                                  ? Colors.green
                                  : data['overallAvgAttendance'] >= 50
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Class-wise Details
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Class-wise Analytics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),

                if (classDetails.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No classes yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: classDetails.length,
                    itemBuilder: (context, index) {
                      var classData = classDetails[index];
                      return _buildClassCard(classData);
                    },
                  ),

                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classData) {
    List<Map<String, dynamic>> studentsList =
        classData['studentsList'] as List<Map<String, dynamic>>;

    // Get students with low attendance (below 75%)
    List<Map<String, dynamic>> lowAttendanceStudents =
        studentsList.where((s) => s['percentage'] < 75).toList();

    Color percentageColor;
    if (classData['avgAttendance'] >= 75) {
      percentageColor = Colors.green;
    } else if (classData['avgAttendance'] >= 50) {
      percentageColor = Colors.orange;
    } else {
      percentageColor = Colors.red;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.class_, color: Colors.deepPurple),
        ),
        title: Text(
          classData['className'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Code: ${classData['classCode']}'),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: percentageColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${classData['avgAttendance'].toStringAsFixed(1)}%',
            style: TextStyle(
              color: percentageColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      Icons.people,
                      'Students',
                      '${classData['enrolledStudents']}',
                      Colors.blue,
                    ),
                    _buildStatItem(
                      Icons.event,
                      'Sessions',
                      '${classData['sessions']}',
                      Colors.orange,
                    ),
                    _buildStatItem(
                      Icons.analytics,
                      'Avg Attendance',
                      '${classData['avgAttendance'].toStringAsFixed(1)}%',
                      percentageColor,
                    ),
                  ],
                ),

                if (lowAttendanceStudents.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Students with Low Attendance (<75%)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ...lowAttendanceStudents.map((student) {
                    Color statusColor =
                        student['percentage'] >= 50
                            ? Colors.orange
                            : Colors.red;
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              student['studentName'],
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            '${student['attended']}/${student['total']} (${student['percentage'].toStringAsFixed(0)}%)',
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],

                if (classData['enrolledStudents'] == 0) ...[
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'No students enrolled yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
