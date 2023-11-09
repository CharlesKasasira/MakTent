import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PreviewScreen extends StatefulWidget {
  Map pastPaper;
  PreviewScreen(this.pastPaper, {Key? key}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final supabase = Supabase.instance.client;
  late PDFDocument pdfDocument;

  Future<void> loadDocument() async {
    try {
      PDFDocument doc = await PDFDocument.fromURL(widget.pastPaper['file_url']);
      setState(() {
        pdfDocument = doc;
      });
    } catch(error){
      print('Error loading PDF: $error');
    }
    
  }

  @override
  void initState() {
    pdfDocument = PDFDocument();
    loadDocument();

    super.initState();
  }

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
        child: pdfDocument == null
          ? Center(child: CircularProgressIndicator())
          : Container(child: PDFViewer(document: pdfDocument)),
      ),
    );
  }
}