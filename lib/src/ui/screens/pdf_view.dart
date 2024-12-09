import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatefulWidget {
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String _pdfPath = '';

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    String pdfPath = await _loadFromAsset('assets', 'app_intro.pdf');
    setState(() {
      _pdfPath = pdfPath;
    });
  }

  Future<String> _loadFromAsset(String folder, String filename) async {
    final ByteData data = await rootBundle.load('$folder/$filename');
    final String tempPath = (await getTemporaryDirectory()).path;
    final File file = File('$tempPath/$filename');
    await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction'),
      ),
      body: Center(
        child: _pdfPath.isNotEmpty
            ? PDFView(
                filePath: _pdfPath,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,
                onRender: (_pages) {},
                onError: (error) {},
                onPageError: (page, error) {},
                onViewCreated: (PDFViewController viewController) {},
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
