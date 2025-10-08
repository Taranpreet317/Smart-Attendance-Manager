import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

Future<void> Createclass({
  required teacherId,
  required String className,
  required String classCode,
}) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(teacherId)
      .collection("Classes")
      .add({'className': className, 'classCode': classCode});
}
