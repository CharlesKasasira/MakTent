import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text("Makerere Past Papers", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        actions: const [
          Icon(Icons.info_outline, color: Colors.white,),
          SizedBox(width: 20,)
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52.0),
          child: Container()
        ),
      );
  }
}