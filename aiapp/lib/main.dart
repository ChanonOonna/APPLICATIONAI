import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'service.dart';
import 'result.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Upload App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
  bool _isProcessing = false; // เพิ่มตัวแปรสถานะการประมวลผล

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

  // ฟังก์ชันเพื่อแสดง popup ระหว่างการประมวลผล พร้อมปุ่มยกเลิก
  Future<void> _showProcessingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // ห้ามปิด popup จนกว่าจะกดยกเลิก
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Expanded(child: Text("Processing video, please wait...")),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // หยุดการประมวลผลและปิด popup
                    setState(() {
                      _isProcessing = false;
                    });
                    Navigator.pop(context); // ปิด popup
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null) {
      setState(() {
        _isProcessing = true; // เริ่มประมวลผล
      });

      // แสดง popup ระหว่างประมวลผล
      _showProcessingDialog(context);

      apiService.sendVideo(_videoFile!);
      apiService.listenForResults((videoUrl) {
        if (_isProcessing) {
          Navigator.pop(context); // ปิด popup เมื่อประมวลผลเสร็จ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(videoUrl: videoUrl),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Video')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _videoFile == null
                  ? Text('No video selected.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                  : Text('Selected video: ${_videoFile!.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Pick Video'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _uploadVideo,
                child: Text('Upload'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
