import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_attendance_manager/domain/constants/appcolors.dart';
// import 'package:smart_attendance_manager/repository/screens/teacher/createclass/createclass.dart';
import 'package:smart_attendance_manager/repository/screens/teacher/createclass/createclasspage.dart';
import 'package:smart_attendance_manager/repository/screens/teacher/sessionQR/sessionqrdialog.dart';
import 'package:smart_attendance_manager/repository/widgets/uihelper.dart';

class Teacherdashboard extends StatefulWidget {
  final String username;
  const Teacherdashboard({super.key, required this.username});
  @override
  State<StatefulWidget> createState() => _TeacherdashboardState();
}

class _TeacherdashboardState extends State<Teacherdashboard> {
  late String username;
  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  Future<Map<String, dynamic>> createAttendanceSession(
    String teacherId,
    String classId,
    String className,
  ) async {
    try {
      String sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      DateTime expiresAt = DateTime.now().add(Duration(minutes: 10));

      Map<String, dynamic> sessionData = {
        'sessionId': sessionId,
        'classId': classId,
        'className': className,
        'teacherId': teacherId,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(teacherId)
          .collection('Classes')
          .doc(classId)
          .collection('sessions')
          .doc(sessionId)
          .set(sessionData);
      return {
        'sessionId': sessionId,
        'classId': classId,
        'teacherId': teacherId,
        'expiresAt': expiresAt.toIso8601String(),
      };
    } catch (e) {
      print('Error creating session: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${e}')));
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    String teacherId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: Appcolors.Backroundgradient(),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Uihelper.CustomText(
                    text: "Welcome back ,",
                    color: Colors.white,
                    fontweight: FontWeight.w400,
                    fontsize: 20,
                  ),
                  SizedBox(height: 10),
                  Uihelper.CustomText(
                    text: username,
                    color: Colors.white,
                    fontweight: FontWeight.bold,
                    fontsize: 30,
                  ),

                  // Add more widgets here for the dashboard content
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Uihelper.CustomText(
                text: "Quick Actions ",
                color: Colors.black.withValues(alpha: 80),
                fontweight: FontWeight.w500,
                fontsize: 22,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      // behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    Createclasspage(teacherId: teacherId),
                          ),
                        );
                        print("Tapped");
                      },
                      child: Uihelper.CustomContainer(
                        icon: Icons.add,
                        text1: "Create Class",
                        text2: "Start a new class",
                        circlecolor: Colors.blue,
                        iconcolor: Colors.white,
                        containercolor: Color.fromARGB(255, 233, 240, 255),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {},
                      child: Uihelper.CustomContainer(
                        icon: Icons.analytics,
                        text1: "Analytics",
                        text2: "View your Analytics",
                        circlecolor: Colors.green,
                        iconcolor: Colors.white,
                        containercolor: const Color.fromARGB(
                          255,
                          224,
                          240,
                          232,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
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
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(teacherId)
                      .collection("Classes")
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      height: 300,
                      width: 350,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(height: 10),
                          Icon(
                            Icons.school,
                            color: const Color.fromARGB(255, 160, 156, 156),
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Uihelper.CustomText(
                            text: "No Classes Yet",
                            color: const Color.fromARGB(255, 34, 34, 34),
                            fontweight: FontWeight.w500,
                            fontsize: 25,
                          ),
                          SizedBox(height: 10),
                          Uihelper.CustomText(
                            text: "Create your first class to get started with",
                            color: const Color.fromARGB(255, 160, 156, 156),
                            fontweight: FontWeight.w400,
                            fontsize: 15,
                          ),
                          Uihelper.CustomText(
                            text: "attendance mangement",
                            color: const Color.fromARGB(255, 160, 156, 156),
                            fontweight: FontWeight.w400,
                            fontsize: 15,
                          ),
                          SizedBox(height: 20),
                          Uihelper.CustomButton(
                            text: "Create First Class",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          Createclasspage(teacherId: teacherId),
                                ),
                              );
                            },
                            backgroundColor: Colors.deepPurpleAccent,
                            textColor: Colors.white,
                            width: 200,
                            height: 50,
                            fontsize: 15,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var classData =
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                    var classId = snapshot.data!.docs[index].id;

                    return Dismissible(
                      key: Key(classId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text("Delete Class"),
                                content: Text(
                                  "Are you sure you want to delete '${classData['className']}'?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(teacherId)
                              .collection("Classes")
                              .doc(classId)
                              .delete();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${classData['className']} deleted",
                              ),
                            ),
                          );
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(classData['className'] ?? "No Name"),
                          subtitle: Text("Code: ${classData['classCode']}"),
                          trailing: IconButton(
                            onPressed: () async {
                              Map<String, dynamic> sessionData =
                                  await createAttendanceSession(
                                    teacherId,
                                    classId,
                                    classData['className'],
                                  );

                              String qrData = jsonEncode(sessionData);
                              showDialog(
                                context: context,
                                builder:
                                    (context) => Sessionqrdialog(
                                      sessionData:sessionData,
                                      qrData:qrData,
                                      className:classData['className'],
                                    )
                              );
                            },
                            icon: Icon(Icons.qr_code),
                          ),
                          // trailing: Text(classData['status'] ?? "Unknown"),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
