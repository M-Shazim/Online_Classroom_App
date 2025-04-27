import 'package:flutter/material.dart';
import 'package:online_classroom/data/accounts.dart';
import 'package:online_classroom/screens/teacher_classroom/add_class.dart';
import 'package:online_classroom/screens/teacher_classroom/classes_tab.dart';
import 'package:online_classroom/services/auth.dart';
import 'package:online_classroom/data/custom_user.dart';
import 'package:online_classroom/services/updatealldata.dart';
import 'package:provider/provider.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = Provider.of<CustomUser?>(context);
    final account = getAccount(user?.uid ?? '');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Classes',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Hi, ${account?.firstName ?? 'Teacher'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.logout,
                            color: Colors.blue.shade700,
                            size: 24,
                          ),
                          onPressed: () async {
                            await _auth.signOut();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: ClassesTab(account),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddClass(),
            ),
          ).then((_) async {
            await updateAllData(); // Wait for data update
            setState(() {});        // Then rebuild the UI
          });

        },
        backgroundColor: Colors.blue.shade600,
        elevation: 2,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:online_classroom/data/accounts.dart';
// import 'package:online_classroom/screens/teacher_classroom/add_class.dart';
// import 'package:online_classroom/screens/teacher_classroom/classes_tab.dart';
// import 'package:online_classroom/services/auth.dart';
// import 'package:online_classroom/data/custom_user.dart';
// import 'package:provider/provider.dart';
//
// class TeacherHomePage extends StatefulWidget {
//   @override
//   _TeacherHomePageState createState() => _TeacherHomePageState();
// }
//
// class _TeacherHomePageState extends State<TeacherHomePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthService _auth = AuthService();
//     final user = Provider.of<CustomUser?>(context);
//     var account = getAccount(user!.uid);
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.5,
//         title: Text(
//           "My Classes",
//           style: TextStyle(
//               color: Colors.black, fontFamily: "Roboto", fontSize: 22),
//         ),
//         backgroundColor: Colors.white,
//         actions: [
//           Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Text("Welcome, " + (account!.firstName as String),
//                 style: TextStyle(color: Colors.black, fontSize: 16),
//               ),
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.logout,
//               color: Colors.black87,
//               size: 30,
//             ),
//             onPressed: () async {
//               await _auth.signOut();
//             },
//           ),
//         ],
//       ),
//       body: ClassesTab(account),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => AddClass(),
//               )).then((_) => setState(() {}));
//         },
//         backgroundColor: Colors.blue,
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 32,
//         ),
//       ),
//     );
//   }
// }
