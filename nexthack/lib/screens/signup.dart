import 'package:flutter/material.dart';
import 'package:nexthack/reusable.dart';
import 'package:nexthack/screens/chatscreen.dart';

class signupscreen extends StatefulWidget {
  const signupscreen({super.key});

  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen> {
  TextEditingController _emailtextcontroller = TextEditingController();
  TextEditingController _passwordtextcontroller = TextEditingController();
  TextEditingController _usernametextcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.deepPurple[300]),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                useTextField("Enter UserName", Icons.person_outline, false,
                    _usernametextcontroller),
                const SizedBox(
                  height: 20,
                ),
                useTextField("Enter EmailID", Icons.mail_outline, false,
                    _emailtextcontroller),
                const SizedBox(
                  height: 20,
                ),
                useTextField("Enter Password", Icons.password_outlined, true,
                    _passwordtextcontroller),
                const SizedBox(
                  height: 20,
                ),
                signinsignupbutton(context, false, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => chatscreen()));
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
