import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PreviewScreen extends StatefulWidget {
  Map pastPaper;
  PDFDocument pdfDocument;
  PreviewScreen(this.pastPaper, this.pdfDocument, {Key? key}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("${widget.pastPaper['name']} Preview", style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        actions: const [
          Icon(Icons.download_for_offline_outlined),
          SizedBox(width: 8,),
          Icon(Icons.share),
          SizedBox(width: 20,)
        ],
      ),
      body: Center(
        // ignore: unnecessary_null_comparison
        child: widget.pdfDocument == null
          ? const Center(child: CircularProgressIndicator(color: Colors.green,))
          : PDFViewer(document: widget.pdfDocument, 
            progressIndicator: const CircularProgressIndicator(color: Colors.green,),),
      ),
    );
  }
}