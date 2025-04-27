// CustomUser class to hold the user data
import 'package:firebase_auth/firebase_auth.dart';

class CustomUser {
  final String? uid;
  final String? email;

  CustomUser({this.uid, this.email});
}

// Convert Firebase user to CustomUser (fix casting issues)
CustomUser? _convertUser(User? user) {
  if (user == null) {
    return null;
  } else {
    return CustomUser(uid: user.uid, email: user.email);
  }
}


