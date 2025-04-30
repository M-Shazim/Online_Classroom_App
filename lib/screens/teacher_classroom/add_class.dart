import 'package:flutter/material.dart';
import 'package:online_classroom/data/custom_user.dart';
import 'package:online_classroom/services/classes_db.dart';
import 'package:online_classroom/services/updatealldata.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  String className = "";
  String description = "";
  Color uiColor = Colors.blue;
  Color _tempShadeColor = Colors.blue;

  final _formKey = GlobalKey<FormState>();

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade900,
            ),
          ),
          content: content,
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Select',
                style: TextStyle(color: Colors.blue.shade700),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => uiColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() {
    _openDialog(
      "Choose Accent Color",
      MaterialColorPicker(
        selectedColor: uiColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        circleSize: 40,
      ),
    );
  }

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
                            'Create a Class',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Set up your new class',
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
                          SizedBox(height: 16),

                          // Description Field
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Description',
                              prefixIcon: Icon(Icons.description_outlined),
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
                            maxLines: 5,
                            onChanged: (val) {
                              setState(() => description = val);
                            },
                          ),
                          SizedBox(height: 16),

                          // Color Picker Button
                          OutlinedButton(
                            onPressed: _openColorPicker,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Accent Color',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                CircleColor(
                                  color: uiColor,
                                  circleSize: 30,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          // Add Button
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (user != null) {
                                  // Show loading spinner
                                  showDialog(
                                    context: context,
                                    barrierDismissible:
                                        false, // Prevent user from dismissing
                                    builder: (_) => Center(
                                        child: CircularProgressIndicator()),
                                  );

                                  try {
                                    // Add class to the database
                                    await ClassesDB(user: user).updateClasses(
                                      className,
                                      description,
                                      uiColor,
                                    );

                                    // Call updateAllData if necessary
                                    await updateAllData();

                                    // Refresh the class list by fetching the updated classes
                                    List? classes = await ClassesDB()
                                        .createClassesDataList();

                                    // Update the UI (if needed)
                                    setState(() {
                                      // Update your local class list if you're using state management
                                    });

                                    // Close the loading spinner
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'New Class Created. Popping up in a minute.')),
                                    );

                                    // Go back to the previous screen
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    // Close the loading spinner in case of error
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();

                                    // Show an error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to create class: ${e.toString()}')),
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
                              'Create Class',
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
// import 'package:online_classroom/data/custom_user.dart';
// import 'package:online_classroom/services/classes_db.dart';
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
//   String description = "";
//   Color uiColor = Colors.blue;
//   Color _tempShadeColor = Colors.blue;
//
//   // for form validation
//   final _formKey = GlobalKey<FormState>();
//
//   void _openDialog(String title, Widget content) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           contentPadding: const EdgeInsets.all(6.0),
//           title: Text(title),
//           content: content,
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: Navigator.of(context).pop,
//             ),
//             TextButton(
//               child: Text('Select'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() => uiColor = _tempShadeColor);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _openColorPicker() async {
//     _openDialog(
//       "Color picker",
//       MaterialColorPicker(
//         selectedColor: uiColor,
//         onColorChange: (color) => setState(() => _tempShadeColor = color)
//       ),
//     );
//   }
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
//             "Add Class",
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
//                     TextFormField(
//                       decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder()),
//                       maxLines: 5,
//                       onChanged: (val) {
//                         setState(() {
//                           description = val;
//                         });
//                       },
//                     ),
//
//                     SizedBox(height: 20.0),
//
//
//                     OutlinedButton(
//                       onPressed: () {
//                         _openColorPicker();
//                         setState(() => {});
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Accent Color",
//                                 style: TextStyle(color: Colors.black87, fontSize: 14)),
//                             CircleColor(
//                               color: uiColor,
//                               circleSize: 30,
//                               onColorChoose: (color) {
//                                 setState(() => {uiColor = color});
//                               },
//                             ),
//                           ]
//                         )
//                       )
//                     ),
//
//                     SizedBox(height: 20.0),
//
//                     // Login  button
//                     ElevatedButton(
//                       child: Text("Add",
//                           style: TextStyle(
//                               color: Colors.white, fontFamily: "Roboto",
//                               fontSize: 22)
//                       ),
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate())  {
//                           await ClassesDB(user: user).updateClasses(className, description, uiColor);
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
