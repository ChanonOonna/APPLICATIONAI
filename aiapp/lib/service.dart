import 'dart:html' as html;
import 'dart:typed_data';

class ApiService {
  final String baseUrl;
  late html.WebSocket _socket;

  ApiService(this.baseUrl) {
    _socket = html.WebSocket(baseUrl);
  }

  void sendVideo(html.File videoFile) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(videoFile);

    reader.onLoadEnd.listen((e) async {
      if (reader.result != null) {
        final Uint8List data = reader.result as Uint8List;
        print('Sending video of size: ${data.lengthInBytes} bytes');
        _socket.send(data);  // ส่งข้อมูลผ่าน WebSocket
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
      onResult(event.data);
    });
  }
}
