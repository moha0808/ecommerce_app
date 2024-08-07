import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/home_page.dart';

class Openpage extends StatefulWidget {
  @override
  _OpenpageState createState() => _OpenpageState();
}

class _OpenpageState extends State<Openpage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Image.asset(
              //   'images/Online.png', // Replace with your image path
              //   height: 300,
              // ),
              Positioned(
                // Adjust this value as needed to position the CircleAvatar
                child: CircleAvatar(
                  radius: 100, // Adjust the radius as needed
                  backgroundImage: AssetImage(
                      'images/Online.png'), // Replace with your avatar image path
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
