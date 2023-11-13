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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("MakTent is an application by Students to help ease the access of past papers and other academic resources on campus.", style: TextStyle(fontSize: 18, color: Colors.grey.shade800),),
            Text("Version 0.0.1", style: TextStyle(fontSize: 15, color: Colors.grey.shade600),),
          ],
        ),
      ),
    );
  }
}