import 'package:flutter/material.dart';
import 'first.dart' ;

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // พื้นหลัง
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pic1.png'), // เปลี่ยนเป็นที่อยู่ของภาพพื้นหลัง
                fit: BoxFit.cover, // ทำให้ภาพเต็มพื้นที่
              ),
            ),
          ),
          // ข้อมูลสมาชิก
          Center( // ใช้ Center เพื่อจัดกลางหน้าจอ
            child: Container(
              width: 400, // กำหนดความกว้างของกรอบ
              padding: const EdgeInsets.all(16.0), // เพิ่ม padding รอบ ๆ
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่ตรงกลางทั้งแนวตั้งและแนวนอน
                crossAxisAlignment: CrossAxisAlignment.start, // จัดข้อความชิดซ้าย
                children: [
                  // สมาชิกคนที่ 1
                  Container(
                    width: 400,
                    height: 200,
                    padding: EdgeInsets.all(16.0), // เพิ่ม padding ภายในกรอบ
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 63, 176, 233).withOpacity(0.8), // สีพื้นหลังกรอบ (โปร่งใส)
                      borderRadius: BorderRadius.circular(8.0), // มุมกรอบที่โค้ง
                      border: Border.all(color: Color.fromARGB(255, 28, 26, 142), width: 2), // กรอบสี
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // จัดข้อความชิดซ้าย
                      children: [
                        Text(
                          'สมาชิกคนที่ 1',
                          style: TextStyle(
                            fontSize: 30, // ขนาดฟอนต์ที่ใหญ่ขึ้น
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5), // เว้นระยะห่างเล็กน้อย
                        Text(
                          'ชื่อ: ชานน อุณหะจิรังรักษ์',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text(
                          'รหัสนิสิต: 6521650815',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // เพิ่มระยะห่างระหว่างสมาชิกแต่ละคน
                  
                  // สมาชิกคนที่ 2
                  Container(
                    width: 400,
                    height: 200,
                    padding: EdgeInsets.all(16.0), // เพิ่ม padding ภายในกรอบ
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 63, 176, 233).withOpacity(0.8), // สีพื้นหลังกรอบ (โปร่งใส)
                      borderRadius: BorderRadius.circular(8.0), // มุมกรอบที่โค้ง
                      border: Border.all(color: Color.fromARGB(255, 28, 26, 142), width: 2), // กรอบสี
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // จัดข้อความชิดซ้าย
                      children: [
                        Text(
                          'สมาชิกคนที่ 2',
                          style: TextStyle(
                            fontSize: 30, // ขนาดฟอนต์ที่ใหญ่ขึ้น
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'ชื่อ: พิมลรัตน์ พร้อมมงคล',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        Text(
                          'รหัสนิสิต: 6521650971',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // เพิ่มระยะห่างระหว่างข้อมูลและปุ่ม

                  // ปุ่มกลับไปหน้าแรก
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // กลับไปที่หน้า first.dart
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CurrencyDetectionApp()), // เปลี่ยนเป็นหน้าที่ต้องการ
                        );
                      },
                      child: Text('กลับไปหน้าหลัก'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
