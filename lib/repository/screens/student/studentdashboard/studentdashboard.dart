import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:smart_attendance_manager/domain/constants/appcolors.dart';
import 'package:smart_attendance_manager/repository/screens/splashscreen/splashscreen.dart';
import 'package:smart_attendance_manager/repository/screens/student/classdetails/classdetailscreen.dart';
import 'package:smart_attendance_manager/repository/screens/student/studentqrscanner/studentqrscanner.dart';
import 'package:smart_attendance_manager/repository/widgets/uihelper.dart';

class StudentDashboard extends StatefulWidget {
  final String username;
  const StudentDashboard({Key? key, required this.username}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late String username;
  String studentId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    print("🚀 StudentDashboard initState");
    print("Username: $username");
    print("Student ID: $studentId");
  }

  Stream<List<Map<String, dynamic>>> getEnrolledClasses() {
    print("🔥 getEnrolledClasses() CALLED");
    return FirebaseFirestore.instance
        .collectionGroup('enrolledStudents')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .asyncMap((snapshot) async {
          print("=== DEBUG START ===");
          print("📦 Snapshot received");
          print("Student ID: $studentId");
          print("Snapshot docs count: ${snapshot.docs.length}");

          List<Map<String, dynamic>> classes = [];

          for (var doc in snapshot.docs) {
            print("\n--- Processing enrollment ---");
            print("Doc ID: ${doc.id}");
            print("Doc path: ${doc.reference.path}");
            print("Doc data: ${doc.data()}");

            // Get the class reference
            var classRef = doc.reference.parent.parent;
            print("Class ref path: ${classRef?.path}");

            if (classRef == null) {
              print("ERROR: classRef is null!");
              continue;
            }

            var classDoc = await classRef.get();
            print("Class doc exists: ${classDoc.exists}");

            if (!classDoc.exists) {
              print("ERROR: Class document doesn't exist!");
              continue;
            }

            Map<String, dynamic> classData =
                classDoc.data() as Map<String, dynamic>;
            print("Class data: $classData");

            // Get teacher info
            var teacherRef = classRef.parent.parent;
            print("Teacher ref path: ${teacherRef?.path}");

            if (teacherRef == null) {
              print("ERROR: teacherRef is null!");
              continue;
            }

            var teacherDoc = await teacherRef.get();
            print("Teacher doc exists: ${teacherDoc.exists}");

            Map<String, dynamic> teacherData =
                teacherDoc.data() as Map<String, dynamic>;
            print("Teacher data: $teacherData");

            // Count total sessions
            var sessionsSnapshot = await classRef.collection('sessions').get();
            int totalSessions = sessionsSnapshot.docs.length;
            print("Total sessions: $totalSessions");

            // Count attended sessions
            int attendedSessions = 0;
            for (var sessionDoc in sessionsSnapshot.docs) {
              var attendanceDoc =
                  await sessionDoc.reference
                      .collection('attendance')
                      .doc(studentId)
                      .get();
              if (attendanceDoc.exists) {
                attendedSessions++;
              }
            }
            print("Attended sessions: $attendedSessions");

            // Calculate attendance percentage
            double attendancePercentage =
                totalSessions > 0
                    ? (attendedSessions / totalSessions) * 100
                    : 0;

            classes.add({
              'classId': classDoc.id,
              'className': classData['className'],
              'classCode': classData['classCode'],
              'teacherName': teacherData['username'],
              'teacherId': teacherDoc.id,
              'totalSessions': totalSessions,
              'attendedSessions': attendedSessions,
              'attendancePercentage': attendancePercentage,
              'enrolledAt': doc.data()['enrolledAt'],
            });

            print("Class added successfully!");
          }
          print("\n=== DEBUG END ===");
          print("Total classes fetched: ${classes.length}");
          return classes;
        });
  }

  // Logout Functionality

  Future<void> logout(BuildContext context) async {
    // Show confirmation dialog
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmLogout == true) {
      try {
        // Sign out from Firebase
        await FirebaseAuth.instance.signOut();

        // Navigate to Splash Screen (which will redirect to Login)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false, // Remove all previous routes
        );
      } catch (e) {
        // Show error if logout fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getEnrolledClasses(),
        builder: (context, snapshot) {
          List<Map<String, dynamic>> classes = snapshot.data ?? [];

          // Calculate overall attendance
          int overallTotal = 0;
          int overallAttended = 0;
          for (var cls in classes) {
            overallTotal += (cls['totalSessions'] as num).toInt();
            overallAttended += (cls['attendedSessions'] as num).toInt();
          }
          double overallPercentage =
              overallTotal > 0 ? (overallAttended / overallTotal) * 100 : 0;
          Color overallColor =
              overallPercentage >= 75
                  ? Colors.green
                  : overallPercentage >= 50
                  ? Colors.orange
                  : Colors.red;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  height: 200,
                  decoration: Appcolors.Backroundgradient(),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Uihelper.CustomText(
                        text: "Welcome back,",
                        color: Colors.white,
                        fontweight: FontWeight.w400,
                        fontsize: 20,
                      ),
                      // SizedBox(height: 10),
                      Row(
                        children: [
                          Uihelper.CustomText(
                            text: username,
                            color: Colors.white,
                            fontweight: FontWeight.bold,
                            fontsize: 30,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                              left: 210,
                              bottom: 30,
                            ),
                            child: IconButton(
                              onPressed: () {
                                logout(context);
                              },
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Overall Attendance
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: overallColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Overall Attendance",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "$overallAttended / $overallTotal sessions",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: overallColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${overallPercentage.toStringAsFixed(0)}%",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: overallColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Quick Action - Scan QR
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Uihelper.CustomText(
                        text: "Quick Action",
                        color: Colors.black.withValues(alpha: 80),
                        fontweight: FontWeight.w500,
                        fontsize: 22,
                      ),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      Studentqrscanner(studentName: username),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple,
                                Colors.deepPurpleAccent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Scan QR Code",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Mark your attendance",
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // My Classes
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Uihelper.CustomText(
                    text: "My Classes",
                    color: Colors.black,
                    fontweight: FontWeight.w500,
                    fontsize: 25,
                  ),
                ),
                SizedBox(height: 20),

                // Classes List
                classes.isEmpty
                    ? Center(child: Text("No classes yet."))
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        var classInfo = classes[index];
                        double percentage = classInfo['attendancePercentage'];
                        Color percentageColor =
                            percentage >= 75
                                ? Colors.green
                                : percentage >= 50
                                ? Colors.orange
                                : Colors.red;

                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Classdetailscreen(
                                        classInfo: classInfo,
                                        studentId: studentId,
                                      ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.class_,
                                          color: Colors.deepPurple,
                                          size: 28,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              classInfo['className'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "Teacher: ${classInfo['teacherName']}",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Divider(height: 1),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${classInfo['attendedSessions']}/${classInfo['totalSessions']} sessions",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "${percentage.toStringAsFixed(0)}%",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: percentageColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
