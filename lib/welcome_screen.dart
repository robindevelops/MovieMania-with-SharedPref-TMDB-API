// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Call checkLoggedIn from initState
    checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://cdn-icons-png.flaticon.com/128/3418/3418899.png",
                height: 100,
              ),
              SizedBox(height: 25),
              Text(
                "Watch thousand of\n hit movies and Tv\n    series for free",
                style: GoogleFonts.aBeeZee(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 30),
              TextField(
                controller: username,
                decoration: InputDecoration(
                  hintText: "User Name",
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: password,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                ),
                onPressed: () {
                  checkUser(username.text, password.text);
                },
                child: Text("Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkUser(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Enter All The Fields"),
            duration: Duration(seconds: 1),
          ),
        );
      } else if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Password Must be greater than 6"),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        registerUser(email, password);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> registerUser(String email, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("email", email);
    await pref.setString("password", password);
    await pref.setBool("isLoggedIn", true);

    Navigator.pushNamedAndRemoveUntil(
        context, './mainscreen', (route) => false);
  }

  Future<void> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isLoggedIn') == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, './mainscreen', (route) => false);
    }
  }
}
