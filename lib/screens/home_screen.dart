import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maktent/screens/about_screen.dart';
import 'package:maktent/screens/course_unit_screen.dart';
import 'package:maktent/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  late List<dynamic> course_units = [];

  Future getCourseUnit() async {
    try {
      final data = await supabase
        .from('course_units')
        .select('*').order("created_at");

      setState(() {
        course_units = data.toList();
      });

      return data;
    } catch (error) {
      kDefaultDialog2("Error", "Something went wrong, Please try to reload");
    }
  }


  @override
  void initState() {
    getCourseUnit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mak Tent", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => AboutScreen(), transition: Transition.fadeIn);
            },
            child: Ink(child: const Icon(Icons.info_outline, color: Colors.white,))),
          const SizedBox(width: 20,)
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52.0),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextFormField(
              decoration: inputDecorationConst.copyWith(
                prefixIcon: const Icon(Icons.search),
                labelText: "Search Course Unit",
                filled: true,
                fillColor: Colors.white
              ),
            ),
          )
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: course_units.length,
        itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Get.to(() => CourseUnitScreen(course_units[index]), transition: Transition.fadeIn);
              },
              child: Ink(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                  leading: const Icon(Icons.edit_document),
                  title: Text(
                    course_units[index]["name"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(course_units[index]["code"]),
                  trailing: Column(
                    children: [
                      const Icon(Icons.remove_red_eye, size: 20,),
                      Text("${course_units[index]["views"]}", style: const TextStyle(fontSize: 12),)
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}