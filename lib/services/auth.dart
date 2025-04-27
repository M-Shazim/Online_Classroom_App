import 'package:online_classroom/data/custom_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<CustomUser?> getFullCustomUser(User? user) async {
  //   if (user == null) return null;
  //
  //   final doc = await FirebaseFirestore.instance.collection("Accounts").doc(user.uid).get();
  //   if (doc.exists) {
  //     return CustomUser.fromFirestore(doc.data() as Map<String, dynamic>);
  //   } else {
  //     return CustomUser(uid: user.uid, email: user.email);
  //   }
  // }

  CustomUser? _convertUser(User? user) {
    if (user == null) {
      return null;
    } else {
      return CustomUser(uid: user.uid, email: user.email);
    }
  }

  // Setting up stream
  // this continuously listens to auth changes (that is login or log out)
  // this will return the user if logged in or return null if not
  Stream<CustomUser?> get streamUser {
    return _auth.authStateChanges().map((User? user) => _convertUser(user));
    // return _auth.authStateChanges().asyncMap((User? user) => getFullCustomUser(user));

  }


  // Sign out part
  Future signOut() async {
    await _auth.signOut();
  }

  // Register part with email and password
// Register part with email and password
  Future<CustomUser?> registerStudent(String email, String password) async {
    print("User data: ${password}, ${email}");

    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      print("User data: ${user?.uid}, ${user?.email}"); // Add this debug log
      return _convertUser(user);
      // return await getFullCustomUser(user);

    } on FirebaseAuthException catch (e) {
      print("Error in registering: ${e.message}");
      // You can handle specific error codes here
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print("Unknown error during registration: $e");
      return null;
    }
  }

// Login part with email and password
  Future<CustomUser?> loginStudent(String email, String password) async {
    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credentials.user;

      // Even if exception occurs later, currentUser might still be valid
      return _convertUser(user);
      // return await getFullCustomUser(user);

    } on FirebaseAuthException catch (e) {
      print("Error in login (FirebaseAuthException): ${e.message}");

      // fallback to currentUser if already logged in
      User? fallbackUser = FirebaseAuth.instance.currentUser;
      if (fallbackUser != null) {
        print("Fallback to currentUser: ${fallbackUser.uid}");
        return _convertUser(fallbackUser);
        // return await getFullCustomUser(fallbackUser);

      }

      return null;
    } catch (e) {
      print("Unknown error during login: $e");

      // fallback again just in case
      User? fallbackUser = FirebaseAuth.instance.currentUser;
      if (fallbackUser != null) {
        print("Fallback to currentUser (catch block): ${fallbackUser.uid}");
        return _convertUser(fallbackUser);
        // return await getFullCustomUser(fallbackUser);

      }


      return null;
    }
  }


}
