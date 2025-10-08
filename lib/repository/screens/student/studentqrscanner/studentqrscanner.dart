import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Studentqrscanner extends StatefulWidget {
  final String studentName;
  const Studentqrscanner({Key? key, required this.studentName})
    : super(key: key);

  @override
  State<StatefulWidget> createState() => StudentqrscannerState();
}

class StudentqrscannerState extends State<Studentqrscanner> {
  MobileScannerController cameracontroller = MobileScannerController();
  bool isProcessing = false;

  Future<void> processQRCode(String qrData) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    try {
      Map<String, dynamic> sessionData = jsonDecode(qrData);

      String sessionId = sessionData['sessionId'];
      String classId = sessionData['classId'];
      String teacherId = sessionData['teacherId'];
      String expiresAtStr = sessionData['expiresAt'];

      // Check if session is expired
      DateTime expiresAt = DateTime.parse(expiresAtStr);
      if (DateTime.now().isAfter(expiresAt)) {
        _showErrorDialog(
          "Session Expired",
          "This attendance session has expired. Please ask your teacher to generate a new QR code.",
        );
        return;
      }

      // Get current student ID
      String studentId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot sessionDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(teacherId)
              .collection('Classes')
              .doc(classId)
              .collection('sessions')
              .doc(sessionId)
              .get();

      if (!sessionDoc.exists) {
        _showErrorDialog("Invalid Session", "This session does not exist.");
        return;
      }

      Map<String, dynamic> sessionInfo =
          sessionDoc.data() as Map<String, dynamic>;

      if (sessionInfo['isActive'] != true) {
        _showErrorDialog(
          "Session Closed",
          "This attendance session has been closed by the teacher.",
        );
        return;
      }

      // Check if student already marked attendance in this session
      DocumentSnapshot attendanceDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(teacherId)
              .collection('Classes')
              .doc(classId)
              .collection('sessions')
              .doc(sessionId)
              .collection('attendance')
              .doc(studentId)
              .get();

      if (attendanceDoc.exists) {
        _showInfoDialog(
          "Already Marked",
          "You have already marked attendance for this session.",
        );
        return;
      }

      DocumentSnapshot classDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(teacherId)
              .collection('Classes')
              .doc(classId)
              .get();

      String className = (classDoc.data() as Map<String, dynamic>)['className'];

      // Check if student is enrolled in class
      DocumentSnapshot enrollmentDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(teacherId)
              .collection('Classes')
              .doc(classId)
              .collection('enrolledStudents')
              .doc(studentId)
              .get();

      // If not enrolled, enroll the student first
      if (!enrollmentDoc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(teacherId)
            .collection('Classes')
            .doc(classId)
            .collection('enrolledStudents')
            .doc(studentId)
            .set({
              'studentName': widget.studentName,
              'studentId': studentId,
              'enrolledAt': FieldValue.serverTimestamp(),
            });
      }

      // Mark attendance
      await FirebaseFirestore.instance
          .collection('users')
          .doc(teacherId)
          .collection('Classes')
          .doc(classId)
          .collection('sessions')
          .doc(sessionId)
          .collection('attendance')
          .doc(studentId)
          .set({
            'studentId': studentId,
            'studentName': widget.studentName,
            'markedAt': FieldValue.serverTimestamp(),
          });

      _showSuccessDialog(className, enrollmentDoc.exists ? false : true);
    } catch (e) {
      print('Error processing QR: $e');
      _showErrorDialog("Error", "Failed to process QR code. Please try again.");
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  void _showSuccessDialog(String className, bool isNewEnrollment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 10),
                Text(
                  isNewEnrollment
                      ? "Enrolled & Attendance Marked!"
                      : "Attendance Marked!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isNewEnrollment) ...[
                  Text(
                    "You've been enrolled in:",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 5),
                ],
                Text(
                  className,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Your attendance has been recorded successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pop(context); // Return to student dashboard
                },
                child: Text("Done", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 60),
                SizedBox(height: 10),
                Text(title, textAlign: TextAlign.center),
              ],
            ),
            content: Text(message, textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 60),
                SizedBox(height: 10),
                Text(title, textAlign: TextAlign.center),
              ],
            ),
            content: Text(message, textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pop(context); // Return to dashboard
                },
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameracontroller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null && !isProcessing) {
                  processQRCode(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 150),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text(
                    "Position QR code within the frame",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Scanning will happen automatically",
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Processing indicator
          if (isProcessing)
            Container(
              color: Colors.black.withValues(alpha: 100),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 15),
                        Text("Processing attendance..."),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameracontroller.dispose();
    super.dispose();
  }
}
