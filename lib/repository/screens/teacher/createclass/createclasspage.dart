import 'package:flutter/material.dart';
import 'package:smart_attendance_manager/domain/constants/appcolors.dart';
import 'package:smart_attendance_manager/repository/screens/teacher/createclass/createclass.dart';
import 'package:smart_attendance_manager/repository/widgets/uihelper.dart';

class Createclasspage extends StatefulWidget {
  final String teacherId;
  const Createclasspage({Key? key, required this.teacherId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreateclasspageState();
}

class _CreateclasspageState extends State<Createclasspage> {
  TextEditingController classnamecontroller = TextEditingController();
  TextEditingController classcodecontroller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    classnamecontroller.dispose();
    classcodecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 135, 66, 255),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Uihelper.CustomText(
          text: "Create Class",
          color: Colors.white,
          fontweight: FontWeight.w500,
          fontsize: 22,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: Appcolors.Backroundgradient(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, color: Colors.white, size: 100),
            Uihelper.CustomText(
              text: "Create New Class",
              color: Colors.white,
              fontweight: FontWeight.bold,
              fontsize: 32,
            ),
            Uihelper.CustomText(
              text: "Set up a new class for attendance tracking",
              color: Colors.white.withValues(alpha: 100),
              fontweight: FontWeight.w500,
              fontsize: 18,
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 90,
              width: 370,
              child: Uihelper.CustomTextField(
                controller: classnamecontroller,
                hintText: "Class name (e.g.,Mathematics 101)",
                textColor: Colors.white,
                fillColor: Color.fromARGB(255, 221, 217, 231).withAlpha(35),
                borderRadius: 15,
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 50)),
                prefixIcon: Icon(Icons.class_, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 90,
              width: 370,
              child: Uihelper.CustomTextField(
                controller: classcodecontroller,
                hintText: "Class Code (e.g.,MATHS 101)",
                textColor: Colors.white,
                fillColor: Color.fromARGB(255, 221, 217, 231).withAlpha(35),
                borderRadius: 15,
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 50)),
                prefixIcon: Icon(Icons.qr_code, color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              height: 90,
              width: 370,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 221, 217, 231).withAlpha(35),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: Colors.white),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Uihelper.CustomText(
                        text: "Student will use the class code to join your",
                        color: Colors.white,
                        fontweight: FontWeight.w400,
                        fontsize: 16,
                      ),
                      SizedBox(height: 5),
                      Uihelper.CustomText(
                        text: "class and access attendance sessions.",
                        color: Colors.white,
                        fontweight: FontWeight.w400,
                        fontsize: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Uihelper.CustomButton(
              text: "Create Class",
              onPressed: () async {
                if (classnamecontroller.text.isEmpty ||
                    classcodecontroller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill in all fields"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                await Createclass(
                  teacherId: widget.teacherId,
                  className: classnamecontroller.text,
                  classCode: classcodecontroller.text,
                );
                Navigator.pop(context);
              },
              backgroundColor: Colors.white,
              textColor: Colors.deepPurpleAccent,
              width: 370,
              height: 70,
              fontsize: 20,
              icon: Icons.add_circle_rounded,
              iconSize: 25,
            ),
          ],
        ),
      ),
    );
  }
}
