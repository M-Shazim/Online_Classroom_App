// ignore_for_file: prefer_const_constructors

import 'package:online_classroom/data/custom_user.dart';
import 'package:online_classroom/screens/loading.dart';
import 'package:online_classroom/screens/wrapper.dart';
import 'package:online_classroom/services/accounts_db.dart';
import 'package:online_classroom/services/updatealldata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Userform extends StatefulWidget {
  const Userform({Key? key}) : super(key: key);

  @override
  _UserformState createState() => _UserformState();
}

class _UserformState extends State<Userform> {
  String firstname = "";
  String lastname = "";
  String type = "student";
  String error = "";

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    final AccountsDB pointer = AccountsDB(user: user!);

    return loading
        ? Loading()
        : Scaffold(
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
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      'Complete Your Profile',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tell us about yourself',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 48),

                    // First Name Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person_outline),
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
                      val!.isEmpty ? 'Enter a first name' : null,
                      onChanged: (val) {
                        setState(() => firstname = val);
                      },
                    ),
                    SizedBox(height: 16),

                    // Last Name Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        prefixIcon: Icon(Icons.person_outline),
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
                      onChanged: (val) {
                        setState(() => lastname = val);
                      },
                    ),
                    SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined),
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
                      value: type.capitalize(),
                      onChanged: (newValue) {
                        setState(() {
                          type = newValue!.toLowerCase();
                        });
                      },
                      items: ['Student', 'Teacher'].map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      dropdownColor: Colors.white,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Register Button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          await pointer.updateAccounts(
                              firstname, lastname, type);
                          await updateAllData();
                          setState(() => loading = false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Wrapper()),
                          );
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
                        'Complete Registration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Error Message
                    if (error.isNotEmpty)
                      Text(
                        error,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}



// // ignore_for_file: prefer_const_constructors
//
// import 'package:online_classroom/data/custom_user.dart';
// import 'package:online_classroom/screens/loading.dart';
// import 'package:online_classroom/screens/wrapper.dart';
// import 'package:online_classroom/services/accounts_db.dart';
// import 'package:online_classroom/services/updatealldata.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class Userform extends StatefulWidget {
//   const Userform({Key? key}) : super(key: key);
//
//   @override
//   _UserformState createState() => _UserformState();
// }
//
// class _UserformState extends State<Userform> {
//   String firstname = "";
//   String lastname = "";
//   String type = "student";
//   String error = "";
//
//   // for form validation
//   final _formKey = GlobalKey<FormState>();
//
//   // for loading screen
//   bool loading = false;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<CustomUser?>(context);
//     final AccountsDB pointer = AccountsDB(user: user!);
//
//     return loading ? Loading() : Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "User Details",
//             style: TextStyle(color: Colors.black),
//           ),
//           backgroundColor: Colors.white,
//         ),
//         body: Container(
//           // form widget
//           child: Form(
//
//             // form key for validation( check above)
//               key: _formKey,
//               child: SingleChildScrollView(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 20.0),
//
//                         // textbox for name
//                         TextFormField(
//                           decoration: InputDecoration(labelText: "First Name", border: OutlineInputBorder()),
//                           validator: (val) =>
//                           val!.isEmpty ? 'Enter an First Name' : null,
//                           onChanged: (val) {
//                             setState(() {
//                               firstname = val;
//                             });
//                           },
//                         ),
//
//                         SizedBox(height: 20.0),
//
//                         // textbox for name
//                         TextFormField(
//                           decoration: InputDecoration(labelText: "Last Name", border: OutlineInputBorder()),
//                           onChanged: (val) {
//                             setState(() {
//                               lastname = val;
//                             });
//                           },
//                         ),
//
//                         SizedBox(height: 20.0),
//
//
//                         DropdownButtonFormField(
//                           decoration: InputDecoration(labelText: "Category", border: OutlineInputBorder()),
//                           value: "Student",
//                           onChanged: (newValue) {
//                             setState(() {
//                               type = (newValue as String).toLowerCase();
//                             });
//                           },
//                           items: ['Student', 'Teacher'].map((location) {
//                             return DropdownMenuItem(
//                               child: new Text(location),
//                               value: location,
//                             );
//                           }).toList(),
//                         ),
//
//                         SizedBox(height: 20.0),
//
//
//                         // register button
//                         ElevatedButton(
//                           child: Text("Register"),
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               setState(() => loading = true);
//
//                               // adding to db
//                               await pointer.updateAccounts(firstname, lastname, type);
//
//                               await updateAllData();
//
//                               setState(() => loading = false);
//
//                               // popping to Wrapper to go to class
//                               Navigator.pushReplacement(context, MaterialPageRoute( builder: (context) => Wrapper()));
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                           ),
//                         ),
//
//                         SizedBox(height: 12.0),
//
//                         // Prints error if any while registering
//                         Text(
//                           error,
//                           style: TextStyle(color: Colors.red, fontSize: 14.0),
//                         )
//                       ],
//                     ),
//                   ))),
//         ));
//   }
// }
