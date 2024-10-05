import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'service.dart';
import 'result.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Upload App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
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
  bool _isProcessing = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioCache player = AudioCache();

  Future<void> _pickVideo() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
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

  Future<void> _showProcessingDialog(BuildContext context) {
    player.play('sound.mp3');

    return showDialog(
      context: context,
      barrierDismissible: false,
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
                    player.play('sound1.mp3');
                    setState(() {
                      _isProcessing = false;
                    });
                    Navigator.pop(context);
                    audioPlayer.stop();
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
        _isProcessing = true;
      });

      _showProcessingDialog(context);

      apiService.sendVideo(_videoFile!);

      apiService.listenForResults((videoUrl) {
        if (_isProcessing) {
          Navigator.pop(context);
          setState(() {
            _isProcessing = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(videoUrl: videoUrl),
            ),
          );

          audioPlayer.stop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Video')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pic1.png'), // ใส่ภาพพื้นหลังที่นี่
            fit: BoxFit.cover, // กำหนดให้ภาพเต็มพื้นที่
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16), // เพิ่ม padding
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8), // กำหนดสีพื้นหลังโปร่งแสง
                    borderRadius: BorderRadius.circular(10), // ทำให้มุมมน
                  ),
                  child: _videoFile == null
                      ? Text(
                          'ยังไม่ได้เลือกคลิปวิดีโอ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // เปลี่ยนสีตัวอักษรให้ชัดเจนขึ้น
                          ),
                        )
                      : Text(
                          'ได้เลือก : ${_videoFile!.name} เเล้ว',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // เปลี่ยนสีตัวอักษรให้ชัดเจนขึ้น
                          ),
                        ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickVideo,
                  child: Text('Pick Video'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _uploadVideo,
                  child: Text('Upload'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
