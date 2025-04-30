import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_classroom/data/custom_user.dart';
import 'package:provider/provider.dart';
import '../student_classroom/classwork_tab.dart';
import '../student_classroom/stream_tab.dart';
import 'package:online_classroom/data/classrooms.dart';
import 'package:online_classroom/screens/student_classroom/people_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_classroom/data/custom_user.dart';

class ClassRoomPage extends StatefulWidget {
  final ClassRooms classRoom;
  final Color uiColor;

  ClassRoomPage({required this.classRoom, required this.uiColor});

  @override
  _ClassRoomPageState createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<ClassRoomPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> removeStudentFromClass(String className, String studentUid) async {
    // Reference to the student document
    DocumentReference studentDoc = FirebaseFirestore.instance.collection('Students').doc(studentUid);

    // Remove the class name from the 'classes' array field in the student document
    try {
      await studentDoc.update({
        'classes': FieldValue.arrayRemove([className]),
      });
      print('Student removed from class');
    } catch (e) {
      print('Error removing student from class: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    String className = widget.classRoom.className;
    Color uiColor = widget.uiColor;

    final tabs = [
      StreamTab(
        className: className,
        uiColor: uiColor,
      ),
      ClassWork(className),
      PeopleTab(
        classRoom: widget.classRoom,
        uiColor: uiColor,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: uiColor,
        elevation: 0.5,
        title: Text(
          className,
          style: TextStyle(
              color: Colors.white, fontFamily: "Roboto", fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_sweep,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () async {
              // Remove the student from the current class
              String userId = user?.uid ?? ""; // Default to empty string if user.uid is null
              print("in kjdbsk"+userId);
              await removeStudentFromClass(className, userId);

              // After removal, navigate back to the previous screen (ClassesTab)

              Navigator.pop(context, true);
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                    content: Text('Class Deleted.')),


              );
            },
          ),
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Stream",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Classwork',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'People',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: uiColor,
        onTap: _onItemTapped,
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:online_classroom/data/custom_user.dart';
// import 'package:online_classroom/screens/student_classroom/people_tab.dart';
// import 'package:provider/provider.dart';
//
// import '../student_classroom/classwork_tab.dart';
// import '../student_classroom/stream_tab.dart';
// import 'package:online_classroom/data/classrooms.dart';
//
// class ClassRoomPage extends StatefulWidget {
//   ClassRooms classRoom;
//   Color uiColor;
//
//   ClassRoomPage({required this.classRoom, required this.uiColor});
//
//   @override
//   _ClassRoomPageState createState() => _ClassRoomPageState();
// }
//
// class _ClassRoomPageState extends State<ClassRoomPage> {
//   int _selectedIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<CustomUser?>(context);
//     String className = widget.classRoom.className;
//     Color uiColor = widget.uiColor;
//
//     final tabs = [
//       StreamTab(
//         className: className,
//         uiColor: uiColor
//       ),
//       ClassWork(className),
//       PeopleTab(
//           classRoom: widget.classRoom,
//           uiColor: uiColor
//       )
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: uiColor,
//         elevation: 0.5,
//         title: Text(
//           className,
//           style: TextStyle(
//               color: Colors.white, fontFamily: "Roboto", fontSize: 22),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.more_vert,
//               color: Colors.white,
//               size: 26,
//             ),
//             onPressed: () {},
//           )
//         ],
//       ),
//       body: tabs[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: "Stream",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Classwork',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'People',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: uiColor,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
