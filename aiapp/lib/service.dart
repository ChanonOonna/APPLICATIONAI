import 'dart:html' as html;
import 'dart:typed_data';

class ApiService {
  final String baseUrl;
  late html.WebSocket _socket;
  bool _isConnected = false;

  ApiService(this.baseUrl) {
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _socket = html.WebSocket(baseUrl);

    _socket.onOpen.listen((event) {
      print('WebSocket is open');
      _isConnected = true;
    });

    _socket.onClose.listen((event) {
      print('WebSocket is closed, reconnecting...');
      _isConnected = false;
      _connectWebSocket(); // สร้างการเชื่อมต่อใหม่
    });

    _socket.onError.listen((error) {
      print('WebSocket error: $error');
    });

    _socket.onMessage.listen((html.MessageEvent event) {
      print('Received result from server: ${event.data}'); // เพิ่มข้อความ logging
      // เรียกใช้ callback หรือฟังก์ชันเพื่อจัดการกับผลลัพธ์ที่ได้รับ
    });
  }

  void sendVideo(html.File videoFile) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(videoFile);

    reader.onLoadEnd.listen((e) async {
      if (reader.result != null) {
        final Uint8List data = reader.result as Uint8List;
        print('Sending video of size: ${data.lengthInBytes} bytes');

        if (_isConnected) {
          _socket.send(data); // ส่งข้อมูลผ่าน WebSocket
          print('Video data sent successfully.'); // เพิ่มข้อความ logging
        } else {
          print('WebSocket not connected. Trying to reconnect...');
          _connectWebSocket(); // สร้างการเชื่อมต่อใหม่ก่อนส่ง
          // คุณอาจต้องรอให้การเชื่อมต่อเปิดก่อนที่จะส่งข้อมูล
        }
      } else {
        print('Error reading video file.');
      }
    });

    reader.onError.listen((error) {
      print('Error reading file: $error');
    });
  }

  Future<void> listenForResults(Function(String videoUrl) onResult) async {
    _socket.onMessage.listen((html.MessageEvent event) {
      print('Received result from server: ${event.data}'); // เพิ่มข้อความ logging
      onResult(event.data);
    });
  }
}
