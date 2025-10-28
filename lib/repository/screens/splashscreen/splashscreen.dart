import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance_manager/domain/constants/appcolors.dart';
import 'package:smart_attendance_manager/repository/screens/loginscreen/loginscreen.dart';
import 'package:smart_attendance_manager/repository/screens/student/studentdashboard/studentdashboard.dart';
import 'package:smart_attendance_manager/repository/screens/teacher/teacherdashboard/teacherdashboard.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
   
    await Future.delayed(Duration(seconds: 2));

   
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    } else {
     
      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          String role = userData['role'] ?? '';
          String username = userData['username'] ?? 'User';

          if (role == 'Teacher') {
           
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Teacherdashboard(username: username),
              ),
            );
          } else if (role == 'Student') {
          
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StudentDashboard(username: username),
              ),
            );
          } else {
           
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Loginscreen()),
            );
          }
        } else {
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Loginscreen()),
          );
        }
      } catch (e) {
        print('Error checking user role: $e');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginscreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: Appcolors.Backroundgradient(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Icon(Icons.qr_code_scanner, size: 120, color: Colors.white),
            SizedBox(height: 30),
            
            Text(
              'Smart Attendance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Manager',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 50),
        
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
