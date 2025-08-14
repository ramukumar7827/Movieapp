import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/custom_widgets.dart';
import 'package:movie_app/home_page.dart';
import 'package:flutter/material.dart';

class SignupPg extends StatefulWidget {
  const SignupPg({Key? key}) : super(key: key);

  @override
  State<SignupPg> createState() => _SignupPgState();
}

class _SignupPgState extends State<SignupPg> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      print("Signed up: ${userCredential.user!.uid}");
      _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else {
        message = 'Error: ${e.message}';
      }
      _showErrorDialog(message);
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text('Your account has been created successfully!'),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
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
          "Sign Up",
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
                 Image.asset(
                  "img/movieicon.png",
                  width: w,
                  height: h * 0.35,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Welcome",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Sign-in to the app",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 20),
                mytextfield("Enter Username", Icons.person_outline, false,
                    _usernameController),
                const SizedBox(height: 20),
                mytextfield("Enter e-mail address", Icons.mail_outline, false,
                    _emailController),
                const SizedBox(height: 20),
                mytextfield("Enter Password", Icons.lock_outline, true,
                    _passwordController),
                const SizedBox(height: 20),
                mybutton(context, "SIGN UP", () {
                  _signUp();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
