import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'dart:ui' as ui; // นำเข้า dart:ui

class ResultPage extends StatefulWidget {
  final String videoUrl;

  ResultPage({required this.videoUrl});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    
    // Register view factory for video element
    ui.platformViewRegistry.registerViewFactory(
      widget.videoUrl,  // ใช้ videoUrl เป็น view type
      (int viewId) {
        final videoElement = html.VideoElement()
          ..src = widget.videoUrl
          ..controls = true
          ..setAttribute('width', '600')
          ..setAttribute('height', '400');
        return videoElement;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Processed Video')),
      body: Center(
        child: SingleChildScrollView( // เพิ่ม SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Processed Video:'),
              SizedBox(height: 10),
              HtmlElementView(viewType: widget.videoUrl), // ใช้ view type ที่ลงทะเบียน
            ],
          ),
        ),
      ),
    );
  }
}
