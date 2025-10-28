import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance_manager/domain/constants/appcolors.dart';
import 'package:smart_attendance_manager/domain/services/firebase/authentication/authentication.dart';
import 'package:smart_attendance_manager/repository/screens/signinscreen/signin.dart';
import 'package:smart_attendance_manager/repository/screens/teacher/teacherdashboard/teacherdashboard.dart';
import 'package:smart_attendance_manager/repository/widgets/uihelper.dart';

class Teacherlogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TeacherloginState();
}

class TeacherloginState extends State<Teacherlogin> {
  TextEditingController t_emailController = TextEditingController();
  TextEditingController t_passwordController = TextEditingController();
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
            Icon(Icons.school, size: 100, color: Colors.white),
            Uihelper.CustomText(
              text: "Teacher Login",
              color: Colors.white,
              fontweight: FontWeight.bold,
              fontsize: 35,
            ),
            SizedBox(height: 10),
            Uihelper.CustomText(
              text: "Sign in to your account",
              color: const Color.fromARGB(142, 241, 239, 239),
              fontweight: FontWeight.w400,
              fontsize: 20,
            ),
            SizedBox(height: 20),

           
            Container(
              height: 70,
              width: 370,
              child: Uihelper.CustomTextField(
                keyboardType: TextInputType.emailAddress,
                controller: t_emailController,
                hintText: "Enter your email",
                textColor: Colors.white,
                fillColor: Color.fromARGB(255, 221, 217, 231).withAlpha(35),
                borderRadius: 15,
                prefixIcon: Icon(Icons.email, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                focusedBorderColor: Colors.white,
              ),
            ),
            SizedBox(height: 15),

          
            Container(
              height: 70,
              width: 370,
              child: Uihelper.CustomTextField(
                controller: t_passwordController,
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
            SizedBox(height: 25),

           
            Uihelper.CustomButton(
              text: "Log In",
              onPressed: () async {
                final flag = await Authentication.loginUser(
                  context: context,
                  emailController: t_emailController,
                  passwordController: t_passwordController,
                );
                DocumentSnapshot userDoc =
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .get();
                String username = userDoc['username'] ?? "Unknown";
                if (flag && context.mounted && userDoc['role'] == 'Teacher') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Teacherdashboard(username: username),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Invalid credentials or not a teacher',
                        style: TextStyle(color: Colors.white),
                      ),
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
