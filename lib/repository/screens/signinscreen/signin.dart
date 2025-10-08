import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_attendance_manager/domain/constants/appcolors.dart';
import 'package:smart_attendance_manager/domain/services/firebase/authentication/authentication.dart';
import 'package:smart_attendance_manager/repository/screens/loginscreen/loginscreen.dart';
import 'package:smart_attendance_manager/repository/widgets/uihelper.dart';

class Signin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SigninState();
}

class SigninState extends State<Signin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isselected1 = true;
  bool _isselected2 = false;
  bool _isobsecure = true;
  String get role => _isselected1 ? "Student" : "Teacher";
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
            Icon(Icons.person_add, size: 100, color: Colors.white),
            Uihelper.CustomText(
              text: "Create Account",
              color: Colors.white,
              fontweight: FontWeight.bold,
              fontsize: 35,
            ),
            SizedBox(height: 10),
            Uihelper.CustomText(
              text: "Join Smart Attendance today",
              color: const Color.fromARGB(142, 241, 239, 239),
              fontweight: FontWeight.w400,
              fontsize: 20,
            ),
            SizedBox(height: 20),
            Container(
              height: 70,
              width: 370,
              child: Uihelper.CustomTextField(
                controller: usernameController,
                hintText: "Username",
                textColor: Colors.white,
                fillColor: Color.fromARGB(255, 221, 217, 231).withAlpha(35),
                borderRadius: 15,
                hintStyle: TextStyle(color: Colors.white),
                focusedBorderColor: Colors.white,
                prefixIcon: Icon(Icons.person, color: Colors.white),
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 70,
              width: 370,
              child: Uihelper.CustomTextField(
                controller: emailController,
                hintText: "Enter your email",
                textColor: Colors.white,
                fillColor: Color.fromARGB(255, 221, 217, 231).withAlpha(35),
                borderRadius: 15,
                hintStyle: TextStyle(color: Colors.white),
                focusedBorderColor: Colors.white,
                prefixIcon: Icon(Icons.email, color: Colors.white),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 15),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 30),
                Uihelper.CustomText(
                  text: "I am a:",
                  color: Colors.white,
                  fontweight: FontWeight.w400,
                  fontsize: 18,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 30),

                // SizedBox(
                //   height: 60,
                //   width: 150,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       setState(() {
                //         _selected = !_selected;
                //       });
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor:
                //           _selected
                //               ? Color.fromARGB(255, 230, 229, 232).withAlpha(50)
                //               : Colors.white,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(Icons.person, color: Colors.white),
                //         SizedBox(width: 10),
                //         Uihelper.CustomText(
                //           text: "Student",
                //           color: const Color.fromARGB(142, 241, 239, 239),
                //           fontweight: FontWeight.w400,
                //           fontsize: 15,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                //
                InkWell(
                  onTap: () {
                    setState(() {
                      _isselected1 = !_isselected1;
                      _isselected2 = false;
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 170,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          _isselected1
                              ? Colors.white
                              : Color.fromARGB(
                                255,
                                221,
                                217,
                                231,
                              ).withAlpha(35),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color:
                              _isselected1
                                  ? Colors.deepPurpleAccent
                                  : Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Student",
                          style:
                              _isselected1
                                  ? TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  )
                                  : TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isselected2 = !_isselected2;
                      _isselected1 = false;
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 170,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          _isselected2
                              ? Colors.white
                              : Color.fromARGB(
                                255,
                                221,
                                217,
                                231,
                              ).withAlpha(35),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color:
                              _isselected2
                                  ? Colors.deepPurpleAccent
                                  : Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Teacher",
                          style:
                              _isselected2
                                  ? TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  )
                                  : TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 70,
              width: 370,
              child: Uihelper.CustomTextField(
                controller: passwordController,
                hintText: "Create your password",
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
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            SizedBox(height: 20),
            Uihelper.CustomButton(
              text: "Create Account",
              onPressed: () async {
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    usernameController.text.isEmpty ||
                    (_isselected1 == false && _isselected2 == false)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All fields are required!'),
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
                      // margin: EdgeInsets.all(16),
                    ),
                  );
                } else {
                  final flag = await Authentication.createUser(
                    context: context,
                    emailController: emailController,
                    passwordController: passwordController,
                    usernameController: usernameController,
                    role: role,
                  );
                  if (flag && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Account Created Successfully!'),
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
                        // margin: EdgeInsets.all(16),
                      ),
                    );
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => Loginscreen()),
                    );
                  }
                }
              },
              backgroundColor: Colors.white,
              textColor: Colors.deepPurpleAccent,
              width: 370,
              height: 60,
              fontsize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
