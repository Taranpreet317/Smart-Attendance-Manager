import 'package:flutter/material.dart';
import 'package:smart_attendance_manager/domain/constants/appcolors.dart';
import 'package:smart_attendance_manager/repository/screens/signinscreen/signin.dart';
import 'package:smart_attendance_manager/repository/screens/studentlogin/studentlogin.dart';
import 'package:smart_attendance_manager/repository/screens/teacherlogin/teacherlogin.dart';
import 'package:smart_attendance_manager/repository/widgets/uihelper.dart';

class Loginscreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginscreenState();
}

class LoginscreenState extends State<Loginscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: Appcolors.Backroundgradient(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Uihelper.CustomText(
                  text: "Smart Attendance",
                  color: Colors.white,
                  fontweight: FontWeight.bold,
                  fontsize: 35,
                ),
              ),
            ),

           
            Container(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Uihelper.CustomText(
                  text: "Modern Attendance Manager with QR Codes",
                  color: Colors.white,
                  fontweight: FontWeight.w400,
                  fontsize: 18,
                ),
              ),
            ),

            SizedBox(height: 100),
          
            Uihelper.CustomButton(
              text: "Teacher Login",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Teacherlogin()),
                );
              },
              backgroundColor: Colors.white,
              textColor: Appcolors.TextColor,
              width: 340,
              height: 60,
              fontsize: 20,
              icon: Icons.school,
              iconColor: Colors.deepPurpleAccent,
              iconSize: 25,
            ),
            SizedBox(height: 20),
            Uihelper.CustomButton(
              text: "Student Login",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Studentlogin()),
                );
              },
              backgroundColor: Colors.white,
              textColor: Appcolors.TextColor,
              width: 340,
              height: 60,
              fontsize: 20,
              icon: Icons.person,
              iconColor: Colors.deepPurpleAccent,
              iconSize: 25,
            ),
            SizedBox(height: 20),
            Uihelper.CustomButton(
              text: "Create New Account",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                );
              },
              backgroundColor: Colors.white,
              textColor: Appcolors.TextColor,
              width: 340,
              height: 60,
              fontsize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
