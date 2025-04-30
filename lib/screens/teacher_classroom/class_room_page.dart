import 'package:flutter/material.dart';
import 'package:online_classroom/screens/teacher_classroom/people_tab.dart';
import 'package:online_classroom/screens/teacher_classroom/announcement_crud/add_announcement.dart';
import '../teacher_classroom/classwork_tab.dart';
import '../teacher_classroom/stream_tab.dart';
import 'package:online_classroom/data/classrooms.dart';
import 'package:online_classroom/services/classes_db.dart';
import 'package:online_classroom/services/updatealldata.dart';

class ClassRoomPage extends StatefulWidget {
  ClassRooms classRoom;
  Color uiColor;
  final Function onClassDeleted;  // Add the callback here

  ClassRoomPage({required this.classRoom, required this.uiColor, required this.onClassDeleted,});

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

  // Method to delete class and show confirmation dialog
  void _deleteClass() async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Delete Class'),
          content: Text('Are you sure you want to delete this class?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()),
      );

      try {
        // Wait for the class deletion to complete
        await ClassesDB().deleteClass(widget.classRoom.className);

        // Close loading spinner
        Navigator.of(context, rootNavigator: true).pop();

        // Notify the parent screen that the class was deleted
        widget.onClassDeleted();

        // Return to the previous screen and update the UI
        Navigator.of(context).pop(true);  // Make sure to return a 'true' value so the previous screen knows it's updated

        // Optionally show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Class deleted successfully')),
        );
      } catch (e) {
        // Close the loading spinner in case of error
        Navigator.of(context, rootNavigator: true).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete class: ${e.toString()}')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final tabs = [
      StreamTab(
          className: widget.classRoom.className,
          uiColor: widget.uiColor
      ),
      ClassWork(widget.classRoom.className),
      PeopleTab(
          classRoom: widget.classRoom,
          uiColor: widget.uiColor
      )
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.uiColor,
        elevation: 0.5,
        title: Text(
          widget.classRoom.className,
          style: TextStyle(
              color: Colors.white, fontFamily: "Roboto", fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
              size: 26,
            ),
            onPressed: _deleteClass, // Trigger the delete method here
          )
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
        selectedItemColor: widget.uiColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddAnnouncement(classRoom: widget.classRoom),
              )).then((_) => setState(() {}));
        },
        backgroundColor: widget.uiColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:online_classroom/screens/teacher_classroom/people_tab.dart';
// import 'package:online_classroom/screens/teacher_classroom/announcement_crud/add_announcement.dart';
//
// import '../teacher_classroom/classwork_tab.dart';
// import '../teacher_classroom/stream_tab.dart';
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
//     final tabs = [
//       StreamTab(
//           className: widget.classRoom.className,
//           uiColor: widget.uiColor
//       ),
//       ClassWork(widget.classRoom.className),
//       PeopleTab(
//           classRoom: widget.classRoom,
//           uiColor: widget.uiColor
//       )
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: widget.uiColor,
//         elevation: 0.5,
//         title: Text(
//           widget.classRoom.className,
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
//         selectedItemColor: widget.uiColor,
//         onTap: _onItemTapped,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => AddAnnouncement(classRoom: widget.classRoom),
//               )).then((_) => setState(() {}));
//         },
//         backgroundColor: widget.uiColor,
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 32,
//         ),
//       ),
//     );
//   }
// }