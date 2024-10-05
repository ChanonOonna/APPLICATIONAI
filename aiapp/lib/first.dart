import 'package:flutter/material.dart';
import 'main.dart';
import 'member.dart';

void main() {
  runApp(CurrencyDetectionApp());
}

class CurrencyDetectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Detection App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CurrencyDetectionPage(),
    );
  }
}

class CurrencyDetectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Detection'),
      ),
      body: Stack(
        children: [
          // ใส่ภาพพื้นหลัง
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pic1.png'), // ที่อยู่ของภาพพื้นหลัง
                fit: BoxFit.cover, // ขยายให้เต็มหน้าจอ
              ),
            ),
          ),
          // เนื้อหาที่อยู่ด้านบนของพื้นหลัง
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'โปรแกรมตรวจจับธนบัตรและเงิน',
                  style: TextStyle(
                    fontSize: 24,
                    color: const Color.fromARGB(255, 0, 0, 0), // ตั้งค่าสีของข้อความให้ดูได้บนพื้นหลัง
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // นำทางไปยังหน้า UploadPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadPage()),
                    );
                  },
                  child: Text('ดำเนินการ'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // เพิ่ม FloatingActionButton เพื่อวางปุ่ม Information ที่มุมขวาล่าง
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // นำทางไปยังหน้า MemberPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MemberPage()),
          );
        },
        child: Icon(Icons.info), // ตั้งค่าเป็นไอคอนข้อมูล
        tooltip: 'Information',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // วางปุ่มที่มุมขวาล่าง
    );
  }
}
