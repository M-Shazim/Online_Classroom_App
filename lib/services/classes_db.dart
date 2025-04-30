
import 'dart:ui';

import 'package:online_classroom/data/custom_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassesDB {

  CollectionReference classReference = FirebaseFirestore.instance.collection("Classes");
  CollectionReference studentReference = FirebaseFirestore.instance.collection("Students");
  CollectionReference announcementReference = FirebaseFirestore.instance.collection("Announcements");

  // uid used to reference the teacher/creator
  CustomUser? user;

  ClassesDB({this.user});


  // function to update in class in database
  Future<void> updateClasses(String className, String description, Color uiColor) async {
    return await classReference.doc(className).set({
      'className': className,
      'description': description,
      'creator': user!.uid,
      'uiColor': uiColor.value.toString(),
    });
  }

  // function to add student to class
  Future<void> updateStudentClasses(String className) async {
    return await studentReference.doc(user?.uid ?? "")
        .update({
      'classes': FieldValue.arrayUnion([className]) // Adds the class to the list
    });
  }

  // Future<void> updateStudentClasses(String className) async {
  //   return await studentReference.doc(user?.uid ?? "" + "___" + className).set({
  //     'className' : className,
  //     'uid' : user!.uid
  //   });
  // }

  // function to make list of accounts from DB
  Future<List?> createClassesDataList() async {
    return await classReference.get().then(  (ss) => ss.docs.toList()  );
  }

  // function to get list of students from DB
  Future<List?> makeStudentsAccountList() async {
    return await studentReference.get().then(  (ss) => ss.docs.toList()  );
  }

  // Method to delete a class and its associated items
  Future<void> deleteClass(String className) async {
    try {
      // 1. Delete associated announcements
      var announcements = await getAnnouncementsByClass(className);
      for (var announcement in announcements) {
        await deleteAnnouncement(announcement);
      }

      // 2. Delete associated students
      var students = await getStudentsByClass(className);
      for (var student in students) {
        await deleteStudent(student);
      }

      // 3. Finally, delete the class itself
      await classReference.doc(className).delete();
      print("Class and associated data deleted successfully.");
    } catch (e) {
      print("Error deleting class: $e");
    }
  }

  // Helper function to get all announcements for a class
  Future<List> getAnnouncementsByClass(String className) async {
    var snapshot = await announcementReference.where("className", isEqualTo: className).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Helper function to delete an announcement
  Future<void> deleteAnnouncement(Map announcement) async {
    String announcementId = announcement["id"];
    await announcementReference.doc(announcementId).delete();
  }

  // Helper function to get all students enrolled in a class
  Future<List> getStudentsByClass(String className) async {
    var snapshot = await studentReference.where("className", isEqualTo: className).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Helper function to delete a student
  Future<void> deleteStudent(Map student) async {
    String studentId = student["uid"];
    await studentReference.doc(studentId).delete();
  }

  // Function to check if a class exists in the database
  Future<bool> doesClassExist(String className) async {
    try {
      var classSnapshot = await classReference.doc(className).get();
      return classSnapshot.exists;
    } catch (e) {
      print("Error checking if class exists: $e");
      return false;
    }
  }

}