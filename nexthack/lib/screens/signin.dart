import 'package:flutter/material.dart';
import 'package:nexthack/reusable.dart';
import 'package:nexthack/screens/chatscreen.dart';
import 'package:nexthack/screens/signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordtextcontroller = TextEditingController();
  TextEditingController _emailtextcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple[300],
          title: Text(
            "NEXTHACK",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.deepPurple[300]),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 90, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/logo.png"),
                SizedBox(
                  height: 30,
                ),
                useTextField("Enter UserName", Icons.person_outline, false,
                    _emailtextcontroller),
                SizedBox(
                  height: 20,
                ),
                useTextField("Enter Password", Icons.lock_outline, true,
                    _passwordtextcontroller),
                SizedBox(
                  height: 20,
                ),
                signinsignupbutton(context, true, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => chatscreen()));
                }),
                signupoption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signupoption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => signupscreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
