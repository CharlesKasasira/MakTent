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
  late List<dynamic> courseUnits = [];
  List<dynamic> filteredUnits = [];
  List<dynamic> results = [];
  late String searchText = "";
  final _focusSearch = FocusNode();

  Future getCourseUnit() async {
    try {
      final data = await supabase
        .from('course_units')
        .select('*').order("created_at");

      setState(() {
        courseUnits = data.toList();
      });

      return data;
    } catch (error) {
      kDefaultDialog2("Error", "Something went wrong, Please try to reload");
    }

    if(courseUnits.isNotEmpty){
      _runFilter();
    }

    _runFilter();
  }


  void _runFilter() {
    if (searchText.isEmpty) {
      results = courseUnits;
    } else {
      results = courseUnits
          .where((unit) => unit['name']
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredUnits = results;
    });

    print("filteredUnits: $filteredUnits");
  }


  @override
  void initState() {
    _initializeData();
  }

  Future<void> _initializeData() async {
      await getCourseUnit();
      _runFilter();
      supabase.channel('public:course_units').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: '*', schema: 'public', table: 'course_units'),
        (payload, [ref]) async {
          await getCourseUnit();
          _runFilter();
        },
      ).subscribe();
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
              Get.to(() => const AboutScreen(), transition: Transition.fadeIn);
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
              focusNode: _focusSearch,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
                _runFilter();
              },
            ),
          )
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getCourseUnit,
        color: Colors.green,
        child: GestureDetector(
          onTap: () {
            _focusSearch.unfocus();
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredUnits.length,
            itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => CourseUnitScreen(filteredUnits[index]), transition: Transition.fadeIn);
                  },
                  child: Ink(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                      leading: const Icon(Icons.edit_document),
                      title: Text(
                        filteredUnits[index]["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(filteredUnits[index]["code"]),
                      trailing: Column(
                        children: [
                          const Icon(Icons.remove_red_eye, size: 20,),
                          Text("${filteredUnits[index]["views"]}", style: const TextStyle(fontSize: 12),)
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}