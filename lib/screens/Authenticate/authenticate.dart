import 'package:online_classroom/screens/Authenticate/login.dart';
import 'package:online_classroom/screens/Authenticate/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showRegister = false;

  void toggle_reg_log() {
    setState(() {
      showRegister = !showRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100, // Background color to match Login/Register
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Define slide direction based on whether we're showing Register or Login
          final offsetAnimation = Tween<Offset>(
            begin: child.key == ValueKey('register')
                ? Offset(1.0, 0.0)
                : Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          // Add fade effect
          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          // Add slight scale effect
          final scaleAnimation = Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            ),
          );
        },
        child: showRegister
            ? Register(
          key: ValueKey('register'),
          toggle_reg_log: toggle_reg_log,
        )
            : Login(
          key: ValueKey('login'),
          toggle_reg_log: toggle_reg_log,
        ),
      ),
    );
  }
}