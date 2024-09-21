import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ResultPage extends StatefulWidget {
  final String videoUrl;

  ResultPage({required this.videoUrl});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // อัปเดต UI เมื่อวิดีโอถูก initialize
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // ทำลายคอนโทรลเลอร์เมื่อปิดหน้าจอ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Processed Video')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // เพิ่มขนาดการแสดงผลวิดีโอ
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Processed Video:',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // ขนาดตัวอักษรปรับตามหน้าจอ
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // ระยะห่างปรับตามหน้าจอ
                  _controller.value.isInitialized
                      ? Container(
                          width: screenWidth, // ขยายให้เต็มหน้าจอ
                          height: screenHeight * 0.6, // เพิ่มความสูงเป็น 60% ของหน้าจอ
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        )
                      : CircularProgressIndicator(),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: screenWidth * 0.08, // ขนาดไอคอนปรับตามหน้าจอ
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(screenWidth * 0.04), // ขนาด padding ปรับตามหน้าจอ
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
