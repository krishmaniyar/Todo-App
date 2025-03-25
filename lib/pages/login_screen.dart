import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/authentication.dart';
import 'package:todo_app/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();

  bool isLogin = true;
  String email = '', password = '', username = '';
  String greet = "Back to productivity! Log in and take control of your day.";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void authenticate() async {
    User? user ;
    if (isLogin) {
      user = await _auth.signInWithEmailAndPassword(email, password);
    }
    else {
      user = await _auth.registerWithEmailAndPassword(email, password);
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 60),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Center(
                        child: Text(
                          "${greet}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 28.0,
                            fontFamily: 'PlayFair',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: MediaQuery.of(context).size.height/2.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30,),
                            Text(
                              isLogin ? "Login" : "Sign Up",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'PlayFair',
                              ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(height: 10),
                            TextField(
                              onChanged: (val) => email = val,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'PlayFair',
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Email',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              onChanged: (val) => password = val,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'PlayFair',
                              ),
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Password',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: authenticate,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                              child: Text(isLogin ? 'Login' : 'Register',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'PlayFair',
                                  )),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                  greet = isLogin ? "Back to productivity! Log in and take control of your day." : "Stay organized, stay productive! Create your account now.";
                                });
                              },
                              child: Text(
                                isLogin ? 'Create an account' : 'Already have an account?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'PlayFair',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}