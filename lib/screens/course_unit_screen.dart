import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maktent/screens/preview_screen.dart';
import 'package:maktent/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseUnitScreen extends StatefulWidget {
  Map courseUnit;
  CourseUnitScreen(this.courseUnit, {Key? key}) : super(key: key);

  @override
  State<CourseUnitScreen> createState() => _CourseUnitScreenState();
}

class _CourseUnitScreenState extends State<CourseUnitScreen> {
  final supabase = Supabase.instance.client;
  late PDFDocument pdfDocument;
  late List<dynamic> pastPapers = [];
  late List<dynamic> tests = [];
  late List<dynamic> courseWorks = [];

  Future<void> loadDocument(fileUrl) async {
    try {
      PDFDocument doc = await PDFDocument.fromURL(fileUrl);
      setState(() {
        pdfDocument = doc;
      });
    } catch(error){
      print('Error loading PDF: $error');
    }
    
  }

  Future getPastPapers() async {
    try {
      final data = await supabase
        .from('past_papers')
        .select('*').eq("course_unit_id", widget.courseUnit["id"]);

      setState(() {
        pastPapers = data.toList();
      });

      return data;
    } catch (error) {
      kDefaultDialog2("Error", "Something went wrong, Please try to reload");
    }
  }

  Future getTests() async {
    try {
      final data = await supabase
        .from('tests')
        .select('*').eq("course_unit_id", widget.courseUnit["id"]);

      setState(() {
        tests = data.toList();
      });

      return data;
    } catch (error) {
      kDefaultDialog2("Error", "Something went wrong, Please try to reload");
    }
  }

  Future getCourseWorks() async {
    try {
      final data = await supabase
        .from('course_works')
        .select('*').eq("course_unit_id", widget.courseUnit["id"]);

      setState(() {
        courseWorks = data.toList();
      });

      return data;
    } catch (error) {
      kDefaultDialog2("Error", "Something went wrong, Please try to reload");
    }
  }

  Future updateViewCount() async {
    try {
      final data = await supabase
        .from('course_units')
        .update({"views": (widget.courseUnit["views"] + 1)})
        .eq("id", widget.courseUnit["id"]);

      return data;
    } catch (error) {
      kDefaultDialog2("Error", "Something went wrong, Please try to reload");
    }
  }

  @override
  void initState() {
    getPastPapers();
    getTests();
    updateViewCount();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text("${widget.courseUnit["name"]}", style: const TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(52.0),
            child: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: [
                Tab(text: 'EXAMS'),
                Tab(text: 'TESTS'),
                Tab(text: 'COURSEWORK'),
              ])
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1 content
            if(pastPapers.isEmpty)
              Center(
                child: Text("No Past exams yet", style: TextStyle(fontSize: 18, color: Colors.grey.shade600),)
              )
            else
              ListView.builder(
              itemCount: pastPapers.length,
              itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  await loadDocument(pastPapers[index]["file_url"]);
                  Get.to(() => PreviewScreen(pastPapers[index], pdfDocument), transition: Transition.fadeIn);
                },
                child: Ink(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                    title: Text(pastPapers[index]["name"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    subtitle: Text("${pastPapers[index]["year"]}"),
                  ),
                ),
              );
            }),

          //Tab 2 content
          if(tests.isEmpty)
            Center(
              child: Text("No tests yet", style: TextStyle(fontSize: 18, color: Colors.grey.shade600),)
            )
          else 
            ListView.builder(
              itemCount: tests.length,
              itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  await loadDocument(tests[index]["file_url"]);
                  Get.to(() => PreviewScreen(tests[index], pdfDocument), transition: Transition.fadeIn);
                },
                child: Ink(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                    title: Text(tests[index]["name"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    subtitle: Text("${tests[index]["year"]}"),
                  ),
                ),
              );
            }),
            

          //Tab 3 content
          if(courseWorks.isEmpty)
              Center(
                child: Text("No CourseWork yet", style: TextStyle(fontSize: 18, color: Colors.grey.shade600),)
              )
          else
            ListView.builder(
              itemCount: courseWorks.length,
              itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  await loadDocument(courseWorks[index]["file_url"]);
                  Get.to(() => PreviewScreen(courseWorks[index], pdfDocument), transition: Transition.fadeIn);
                },
                child: Ink(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                    title: Text(courseWorks[index]["name"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    subtitle: Text("${courseWorks[index]["year"]}"),
                  ),
                ),
              );
            }),
          ] 
        ),
      ),
    );
  }
}