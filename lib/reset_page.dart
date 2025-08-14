import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/custom_widgets.dart'; // Assumes you have mytextfield and mybutton defined here

class resetpg extends StatefulWidget {
  const resetpg({Key? key}) : super(key: key);

  @override
  State<resetpg> createState() => _resetpgState();
}

class _resetpgState extends State<resetpg> {
  final TextEditingController _emailcontrollerrs = TextEditingController();

  void _resetPassword() {
    final email = _emailcontrollerrs.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email address")),
      );
      return;
    }

    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Email Sent"),
          content: const Text("Check your inbox to reset your password."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); 
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Error"),
          content: Text(error.message ?? "Something went wrong"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: w,
        height: h,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                mytextfield(
                  "Enter e-mail address",
                  Icons.mail_outline,
                  false,
                  _emailcontrollerrs,
                ),
                const SizedBox(height: 20),
                mybutton(context, "RESET PASSWORD", _resetPassword),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

