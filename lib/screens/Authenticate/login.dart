// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names

import 'package:online_classroom/screens/loading.dart';
import 'package:online_classroom/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:online_classroom/services/updatealldata.dart';

class Login extends StatefulWidget {
  final Function toggle_reg_log;
  // Login({required this.toggle_reg_log});
  Login({Key? key, required this.toggle_reg_log}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
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
                    // Logo or Title
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 48),

                    // Email Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
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
                      obscureText: true,
                      validator: (val) => val!.length < 6
                          ? 'Password must be 6+ characters'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 24),

                    // Login Button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          await updateAllData();
                          var result =
                          await _auth.loginStudent(email, password);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error =
                              'Error logging in. Please check your credentials.';
                            });
                          } else {
                            print('User Logged in Successfully');
                            setState(() => loading = false);
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
                        'Sign In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Register Button
                    TextButton(
                      onPressed: () {
                        widget.toggle_reg_log();
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
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



// // ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names
//
// import 'package:online_classroom/screens/loading.dart';
// import 'package:online_classroom/services/auth.dart';
// import 'package:flutter/material.dart';
// import 'package:online_classroom/services/updatealldata.dart';
//
// class Login extends StatefulWidget {
//   final Function toggle_reg_log;
//   Login({required this.toggle_reg_log});
//
//   @override
//   _LoginState createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   // Authservice object for logging in
//   // More details inside "services/auth.dart" file
//   final AuthService _auth = AuthService();
//
//   // email and password strings
//   String email = '';
//   String password = '';
//   String error = '';
//
//   // for form validation
//   final _formKey = GlobalKey<FormState>();
//
//   // for loading screen
//   bool loading = false;
//
//   // build func
//   @override
//   Widget build(BuildContext context) {
//
//     // checking if not loading then show the page
//     return loading ? Loading() :Scaffold(
//         // appbar part
//         appBar: AppBar(
//           title: Text("Login",
//               style: TextStyle(color: Colors.black)),
//           backgroundColor: Colors.white,
//           actions: [
//             TextButton.icon(
//               onPressed: () {
//                 widget.toggle_reg_log();
//               },
//               icon: Icon(Icons.person),
//               label: Text('Register'),
//               style: TextButton.styleFrom(backgroundColor: Colors.black),
//             )
//           ],
//         ),
//
//         // body part
//         body: Container(
//           padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//           child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   SizedBox(height: 20.0),
//
//                   // textbox for email
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
//                     validator: (val) => val!.isEmpty ? 'Enter an email' : null,
//                     onChanged: (val) {
//                       setState(() {
//                         email = val;
//                       });
//                     },
//                   ),
//
//                   SizedBox(height: 20.0),
//
//                   // textbox for password
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
//                     obscureText: true,
//                     validator: (val) => val!.length < 6
//                         ? 'Enter a password 6+ chars long'
//                         : null,
//                     onChanged: (val) {
//                       setState(() {
//                         password = val;
//                       });
//                     },
//                   ),
//
//                   SizedBox(height: 20.0),
//
//                   // Login  button
//                   ElevatedButton(
//                     child: Text("Login",
//                         style: TextStyle(
//                             color: Colors.white, fontFamily: "Roboto",
//                             fontSize: 22)
//                     ),
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//
//                         setState(() => loading = true);
//
//                         await updateAllData();
//
//                         // Logging into the account
//                         var result = await _auth.loginStudent(email, password);
//
//                         if (result == null) {
//                           setState(() {
//                             loading = false;
//                             error = 'Some error in logging in! Please check again';
//                           });
//
//
//                         }
//                         else {
//                           print("\t\t\tUser Logged in Successfully");
//
//                           setState(() => loading = false);
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                     ),
//                   ),
//
//                   SizedBox(height: 12.0),
//
//                   // Prints error if any while logging in
//                   Text(
//                     error,
//                     style: TextStyle(color: Colors.red, fontSize: 14.0),
//                   )
//                 ],
//               )),
//         ));
//   }
// }
