import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PreviewScreen extends StatefulWidget {
  Map pastPaper;
  PreviewScreen(this.pastPaper, {Key? key}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("${widget.pastPaper['name']} Preview", style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        actions: [
          const Icon(Icons.download_for_offline_outlined),
          const SizedBox(width: 8,),
          const Icon(Icons.share),
          const SizedBox(width: 20,)
        ],
      ),
      body: Center(
        child: PDFView(
        filePath: "https://hmztmelqhqsooxziulqd.supabase.co/storage/v1/object/public/past_papers/b61cece9-1bf8-41a7-a9d6-1befe68f4561/24hrs%20Take%20Home.pdf?t=2023-11-09T02%3A55%3A28.348Z",
        // placeHolder: Text("Loading PDF..."),
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        // onError: (error) => Center(child: Text('Error: $error')),
      ),
      ),
    );
  }
}