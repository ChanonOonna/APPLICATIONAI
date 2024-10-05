import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class ResultPage extends StatefulWidget {
  final String videoUrl;

  ResultPage({required this.videoUrl});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late VideoPlayerController _controller;
  final AudioCache player = AudioCache(); // สร้าง AudioCache เพื่อเล่นไฟล์จาก assets

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // อัปเดต UI เมื่อวิดีโอถูก initialize
        player.play('sound2.mp3'); // เล่นเสียงจาก assets เมื่อหน้าเปิด
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pic1.png'), // ใส่ภาพพื้นหลังที่ต้องการ
            fit: BoxFit.cover, // ปรับให้พอดีกับขนาดหน้าจอ
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0), // เพิ่ม padding รอบๆ ข้อความ
                      decoration: BoxDecoration(
                        color: Colors.grey, // สีพื้นหลังเป็นสีดำโปร่งใส
                        borderRadius: BorderRadius.circular(8.0), // มุมโค้งมน
                      ),
                      child: Text(
                        'Processed Video:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05, // ขนาดตัวอักษรปรับตามหน้าจอ
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // เปลี่ยนสีตัวอักษรให้ชัดเจนขึ้น
                        ),
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
      ),
    );
  }
}
