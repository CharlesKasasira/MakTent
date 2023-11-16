import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maktent/screens/about_screen.dart';
import 'package:maktent/screens/home_screen.dart';
import 'package:maktent/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final supabase = Supabase.instance.client;
  late List<dynamic> courses = [];
  List<dynamic> filteredCourses = [];
  List<dynamic> results = [];
  late String searchText = "";
  final _focusSearch = FocusNode();

  Future getCourses() async {
    try {
      final data = await supabase
        .from('courses')
        .select('*').order("created_at");

      setState(() {
        courses = data.toList();
      });

      return data;
    } catch (error) {
      kDefaultDialog2("Error", "Something went wrong, Please try to reload");
    }

    if(courses.isNotEmpty){
      _runFilter();
    }

    _runFilter();
  }


  void _runFilter() {
    if (searchText.isEmpty) {
      results = courses;
    } else {
      results = courses
          .where((course) => course['name']
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredCourses = results;
    });
  }


  @override
  void initState() {
    _initializeData();

    super.initState();
  }

  Future<void> _initializeData() async {
      await getCourses();
      _runFilter();
      supabase.channel('public:courses').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: '*', schema: 'public', table: 'courses'),
        (payload, [ref]) async {
          await getCourses();
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
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextFormField(
              decoration: inputDecorationConst.copyWith(
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.green.shade800, width: 2),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.green.shade800, size: 22,),
                labelText: "Search Course",
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
        onRefresh: getCourses,
        color: Colors.green,
        child: GestureDetector(
          onTap: () {
            _focusSearch.unfocus();
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredCourses.length,
            itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    // Get.to(() => CourseUnitScreen(filteredUnits[index]), transition: Transition.fadeIn);
                  },
                  child: Ink(
                    child: ExpansionTile(
                      // contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                      // leading: Container(
                      //   padding: const EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //     color: Colors.green.shade50,
                      //     borderRadius: BorderRadius.circular(75)
                      //   ),
                      //   child: Icon(Icons.school, color: Colors.green.shade300,)),
                      title: Text(
                        filteredCourses[index]["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        ListTile(
                          title: Text('Year 1'),
                          onTap: () {
                            Get.to(() => HomeScreen(), transition: Transition.fadeIn);
                          },
                        ),
                        ListTile(
                          title: Text('Year 2'),
                          onTap: () {
                            Get.to(() => HomeScreen(), transition: Transition.fadeIn);
                          },
                        ),
                        ListTile(
                          title: Text('Year 3'),
                          onTap: () {
                            Get.to(() => HomeScreen(), transition: Transition.fadeIn);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}