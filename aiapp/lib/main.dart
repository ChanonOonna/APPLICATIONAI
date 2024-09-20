import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'service.dart';
import 'result.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Upload App',
      home: UploadPage(),
    );
  }
}

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  html.File? _videoFile;
  final ApiService apiService = ApiService('ws://localhost:4000');

  Future<void> _pickVideo() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'video/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      setState(() {
        _videoFile = files[0];
      });
    });
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null) {
      apiService.sendVideo(_videoFile!);
      apiService.listenForResults((videoUrl) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(videoUrl: videoUrl),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Video')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _videoFile == null
                ? Text('No video selected.')
                : Text('Selected video: ${_videoFile!.name}'),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick Video'),
            ),
            ElevatedButton(
              onPressed: _uploadVideo,
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
