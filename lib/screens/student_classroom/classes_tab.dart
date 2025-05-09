import 'package:flutter/material.dart';
import 'package:online_classroom/data/accounts.dart';
import 'package:online_classroom/data/classrooms.dart';
import 'package:online_classroom/data/custom_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:online_classroom/screens/student_classroom/class_room_page.dart';
import 'package:provider/provider.dart';

class ClassesTab extends StatefulWidget {

  @override
  _ClassesTabState createState() => _ClassesTabState();
}
class _ClassesTabState extends State<ClassesTab> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    var account = getAccount(user!.uid);

    // Fetch the student's classes from the Firestore 'students' collection
    Future<List<String>> fetchStudentClasses(String uid) async {
      var docSnapshot = await FirebaseFirestore.instance.collection('Students').doc(uid).get();

      if (!docSnapshot.exists) {
        // Handle the case where the document doesn't exist
        throw Exception('Student data not found');
      }

      var data = docSnapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        // Handle the case where the data is null
        return []; // or you can return a default value
      }

      return List<String>.from(data['classes'] ?? []); // Get the classes list
    }


    String userId = user?.uid ?? ""; // Default to empty string if user.uid is null
    print(userId);

    return FutureBuilder<List<String>>(
      future: fetchStudentClasses(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // Now you have the student's classes in snapshot.data
        List<String> joinedClasses = snapshot.data ?? [];

        // Filter the classRoomList based on the student's classes
        List _classRoomList = classRoomList.where((classRoom) =>
            joinedClasses.contains(classRoom.className)).toList();

        return ListView.builder(
          itemCount: _classRoomList.length,
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () async {
                // Navigate to ClassRoomPage
                bool? result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ClassRoomPage(
                    uiColor: _classRoomList[index].uiColor,
                    classRoom: _classRoomList[index],
                  ),
                ));

                // If the result is true, refresh the UI (remove the class from the list)
                if (result != null && result) {
                  setState(() {
                    // Refresh the class list after removal
                    _classRoomList.removeAt(index);
                  });
                }
              },
              child: Stack(
                children: [
                  Container(
                    height: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: _classRoomList[index].uiColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 30),
                    width: 220,
                    child: Text(
                      _classRoomList[index].className,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 58, left: 30),
                    child: Text(
                      _classRoomList[index].description,
                      style: TextStyle(fontSize: 14, color: Colors.white, letterSpacing: 1),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 80, left: 30),
                    child: Text(
                      _classRoomList[index].creator.firstName! + " " + _classRoomList[index].creator.lastName!,
                      style: TextStyle(fontSize: 12, color: Colors.white54, letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// class _ClassesTabState extends State<ClassesTab> {
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<CustomUser?>(context);
//     var account = getAccount(user!.uid);
//     List _classRoomList = classRoomList.where((i) => i.students.contains(account)).toList();
//
//     return ListView.builder(
//         itemCount: _classRoomList.length,
//         itemBuilder: (context, int index) {
//           return GestureDetector(
//             onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                 builder: (_) => ClassRoomPage(
//                   uiColor: _classRoomList[index].uiColor,
//                   classRoom: _classRoomList[index],
//                 ))),
//             child: Stack(
//               children: [
//                 Container(
//                   height: 100,
//                   margin: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     // image: DecorationImage(
//                     //   fit: BoxFit.cover, image: classRoomList[index].bannerImg,),
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                     color: _classRoomList[index].uiColor,
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 30, left: 30),
//                   width: 220,
//                   child: Text(
//                     _classRoomList[index].className,
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       letterSpacing: 1,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 58, left: 30),
//                   child: Text(
//                     _classRoomList[index].description,
//                     style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white,
//                         letterSpacing: 1),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 80, left: 30),
//                   child: Text(
//                     _classRoomList[index].creator.firstName! + " " + _classRoomList[index].creator.lastName!,
//                     style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.white54,
//                         letterSpacing: 1),
//                   ),
//                 )
//               ],
//             ),
//           );
//         });
//   }
// }
