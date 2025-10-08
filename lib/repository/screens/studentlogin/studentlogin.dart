import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance_manager/domain/constants/appcolors.dart';
import 'package:smart_attendance_manager/domain/services/firebase/authentication/authentication.dart';
import 'package:smart_attendance_manager/repository/screens/signinscreen/signin.dart';
import 'package:smart_attendance_manager/repository/screens/student/studentdashboard/studentdashboard.dart';
import 'package:smart_attendance_manager/repository/widgets/uihelper.dart';

class Studentlogin extends StatefulWidget {
  const Studentlogin({super.key});
  @override
  State<StatefulWidget> createState() => StudentloginState();
}

class StudentloginState extends State<Studentlogin> {
  TextEditingController s_emailController = TextEditingController();
  TextEditingController s_passwordController = TextEditingController();
  bool _isobsecure = true;
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
            Icon(Icons.person, size: 100, color: Colors.white),
            Uihelper.CustomText(
              text: "Student Login",
              color: Colors.white,
              fontweight: FontWeight.bold,
              fontsize: 35,
            ),
            SizedBox(height: 10),
            Uihelper.CustomText(
              text: "Sign into your account",
              color: const Color.fromARGB(142, 241, 239, 239),
              fontweight: FontWeight.w400,
              fontsize: 20,
            ),
            SizedBox(height: 20),
            Container(
              height: 70,
              width: 370,
              child: Uihelper.CustomTextField(
                controller: s_emailController,
                hintText: "Enter your email",
                textColor: Colors.white,
                fillColor: Color.fromARGB(255, 221, 217, 231).withAlpha(35),
                borderRadius: 15,
                keyboardType: TextInputType.emailAddress,
                hintStyle: TextStyle(color: Colors.white),
                focusedBorderColor: Colors.white,
                prefixIcon: Icon(Icons.email, color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 70,
              width: 370,
              child: Uihelper.CustomTextField(
                controller: s_passwordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: "Enter your password",
                textColor: Colors.white,
                fillColor: Color.fromARGB(255, 221, 217, 231).withAlpha(35),
                borderRadius: 15,
                hintStyle: TextStyle(color: Colors.white),
                focusedBorderColor: Colors.white,
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                obscureText: _isobsecure,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isobsecure = !_isobsecure;
                    });
                  },
                  icon: Icon(
                    _isobsecure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Uihelper.CustomButton(
              text: "Log In",
              onPressed: () async {
                final flag = await Authentication.loginUser(
                  context: context,
                  emailController: s_emailController,
                  passwordController: s_passwordController,
                );
                // Get role from Firestore
                DocumentSnapshot userDoc =
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .get();
                String username = userDoc['username'] ?? "Unknown";
                if (flag && context.mounted && userDoc['role'] == 'Student') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => StudentDashboard(username: username),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Invalid credentials or not a Student"),
                      backgroundColor: Color.fromARGB(
                        255,
                        221,
                        217,
                        231,
                      ).withAlpha(35),
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.fixed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  FirebaseAuth.instance.signOut();
                }
              },
              backgroundColor: Colors.white,
              textColor: Colors.deepPurpleAccent,
              width: 370,
              height: 60,
              fontsize: 18,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                );
              },
              highlightColor: Colors.blueAccent,
              child: Uihelper.CustomText(
                text: "Don't have a account? Register here",
                color: Colors.white,
                fontweight: FontWeight.w500,
                fontsize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
