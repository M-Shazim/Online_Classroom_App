import 'package:flutter/material.dart';
import 'package:online_classroom/data/accounts.dart';
import 'package:online_classroom/data/announcements.dart';
import 'package:online_classroom/data/custom_user.dart';
import 'package:online_classroom/screens/teacher_classroom/announcement_page.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ClassWork extends StatefulWidget {
  final String className;

  ClassWork(this.className);

  @override
  _ClassWorkState createState() => _ClassWorkState();
}

// class _ClassWorkState extends State<ClassWork> {
//   Future<List<String>> fetchStudentClasses(String uid) async {
//     try {
//       var docSnapshot = await FirebaseFirestore.instance.collection('Students').doc(uid).get();
//
//       if (docSnapshot.exists) {
//         var data = docSnapshot.data();
//         print('Student data: $data');
//         // Check if 'classes' exists and is an array
//         return List<String>.from(data?['classes'] ?? []);
//       } else {
//         print('No student data found for UID: $uid');
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching student classes: $e');
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<CustomUser?>(context);
//
//     if (user == null) {
//       return Center(child: Text('User not found'));
//     }
//
//     String userId = user?.uid ?? ""; // Default to empty string if user.uid is null
//     print(userId);
//
//     return FutureBuilder<List<String>>(
//       future: fetchStudentClasses(userId),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No classes found for this student.'));
//         }
//
//         List<String> joinedClasses = snapshot.data!;
//         print('Joined classes: $joinedClasses');
//
//         // Filter classwork based on joined classes
//         List _classWorkList = announcementList.where((announcement) {
//           return announcement.type == "Assignment" &&
//               joinedClasses.contains(announcement.classroom.className);
//         }).toList();
//
//         if (_classWorkList.isEmpty) {
//           return Center(child: Text('No classwork found for the joined classes.'));
//         }
//
//         return ListView.builder(
//           itemCount: _classWorkList.length,
//           itemBuilder: (context, int index) {
//             return InkWell(
//               onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                 builder: (_) => AnnouncementPage(
//                   announcement: _classWorkList[index],
//                 ),
//               )),
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Container(
//                   child: Row(
//                     children: [
//                       Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           color: _classWorkList[index].classroom.uiColor,
//                         ),
//                         child: Icon(
//                           Icons.assignment,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             _classWorkList[index].title,
//                             style: TextStyle(letterSpacing: 1),
//                           ),
//                           Text(
//                             "Due " + _classWorkList[index].dueDate,
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }



class _ClassWorkState extends State<ClassWork> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    List _classWorkList = announcementList.where((i) => i.type == "Assignment" && i.classroom.className == widget.className).toList();

    return ListView.builder(
        itemCount: _classWorkList.length,
        itemBuilder: (context, int index) {
          return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AnnouncementPage(
                announcement: _classWorkList[index]
              ))),
            child:  Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: _classWorkList[index].classroom.uiColor),
                        child: Icon(
                          Icons.assignment,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _classWorkList[index].title,
                            style: TextStyle(letterSpacing: 1),
                          ),
                          Text(
                            "Due " + _classWorkList[index].dueDate,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            )
          );
        }
    );
  }
}
