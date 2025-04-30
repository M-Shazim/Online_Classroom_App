import 'package:flutter/material.dart';
import 'package:online_classroom/data/announcements.dart';
import 'package:online_classroom/data/custom_user.dart';
import 'package:online_classroom/services/classes_db.dart';
import 'package:online_classroom/services/submissions_db.dart';
import 'package:online_classroom/services/updatealldata.dart';
import 'package:provider/provider.dart';

class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  String className = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

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
              // Custom Header with Back Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.blue.shade700,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Join a Class',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Enter the class name to join',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 44), // Balance the layout
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 32),

                          // Class Name Field
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Class Name',
                              prefixIcon: Icon(Icons.class_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                            ),
                            validator: (val) =>
                            val!.isEmpty ? 'Enter a class name' : null,
                            onChanged: (val) {
                              setState(() => className = val);
                            },
                          ),
                          SizedBox(height: 24),

                          // Join Button
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (user != null) {
                                  // Show loading dialog
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => Center(child: CircularProgressIndicator()),
                                  );

                                  try {
                                    bool classExists = await ClassesDB()
                                        .doesClassExist(className);

                                    if (classExists) {
                                      await ClassesDB(user: user)
                                          .updateStudentClasses(className);

                                      for (var announcement in announcementList) {
                                        if (announcement.classroom.className ==
                                            className &&
                                            announcement.type == "Assignment") {
                                          await SubmissionDB().addSubmissions(
                                            user.uid!,
                                            className,
                                            announcement.title,
                                          );
                                        }
                                      }

                                      await updateAllData();
                                      Navigator.of(context)
                                          .pop(); // Close the current screen
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('Class Joined.')),


                                      );

                                      Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading dialog

                                    } else {
                                      Navigator.of(context)
                                          .pop(); // Close loading
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('Class not found!')),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: ${e.toString()}')),
                                    );
                                  }

                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              backgroundColor: Colors.blue.shade600,
                            ),
                            child: Text(
                              'Join Class',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
// import 'package:online_classroom/data/announcements.dart';
// import 'package:online_classroom/data/custom_user.dart';
// import 'package:online_classroom/services/classes_db.dart';
// import 'package:online_classroom/services/submissions_db.dart';
// import 'package:online_classroom/services/updatealldata.dart';
// import 'package:provider/provider.dart';
//
// class AddClass extends StatefulWidget {
//
//   @override
//   _AddClassState createState() => _AddClassState();
// }
//
// class _AddClassState extends State<AddClass> {
//
//   String className = "";
//
//   // for form validation
//   final _formKey = GlobalKey<FormState>();
//
//
//   // build func
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<CustomUser?>(context);
//
//     return Scaffold(
//       // appbar part
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           elevation: 0.5,
//           title: Text(
//             "Join Class",
//             style: TextStyle(
//                 color: Colors.white, fontFamily: "Roboto", fontSize: 22),
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(
//                 Icons.more_vert,
//                 color: Colors.white,
//                 size: 26,
//               ),
//               onPressed: () {},
//             )
//           ],
//         ),
//
//         // body part
//         body: ListView(
//           padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//           children: [
//             Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20.0),
//
//                     TextFormField(
//                       decoration: InputDecoration(labelText: "Class Name", border: OutlineInputBorder()),
//                       validator: (val) => val!.isEmpty ? 'Enter a class name' : null,
//                       onChanged: (val) {
//                         setState(() {
//                           className = val;
//                         });
//                       },
//                     ),
//
//                     SizedBox(height: 20.0),
//
//                     ElevatedButton(
//                       child: Text("Join",
//                           style: TextStyle(
//                               color: Colors.white, fontFamily: "Roboto",
//                               fontSize: 22)
//                       ),
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate())  {
//                           await ClassesDB(user: user).updateStudentClasses(className);
//
//                           for(int i=0; i<announcementList.length; i++) {
//                             if(announcementList[i].classroom.className == className && announcementList[i].type == "Assignment") {
//
//                               await SubmissionDB().addSubmissions(user?.uid ?? "", className, announcementList[i].title);
//                             }
//                           }
//
//                           await updateAllData();
//
//                           Navigator.of(context).pop();
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         minimumSize: Size(150, 50),
//                       ),
//                     )
//                   ],
//                 ))],
//         ));
//   }
// }