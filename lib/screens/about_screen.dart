import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("About Us", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text("MakTent is an application by students to help in the access of past papers and other academic resources on campus", style: TextStyle(fontSize: 18),),
        ),
      ),
    );
  }
}