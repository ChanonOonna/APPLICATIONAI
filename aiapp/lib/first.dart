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

class CurrencyDetectionPage extends StatefulWidget {
  @override
  _CurrencyDetectionPageState createState() => _CurrencyDetectionPageState();
}

class _CurrencyDetectionPageState extends State<CurrencyDetectionPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to the introduction page
        // You can create an IntroductionPage and navigate to it
        break;
      case 1:
        // Navigate to the main page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
        break;
      case 2:
        // Navigate to the member page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MemberPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Detection'),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pic1.png'), // Path to the background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Content on top of the background
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20), // Adjust space for the AppBar
                // Image in the center at the top
                SizedBox(
                  width: 200,
                  height: 300 ,
                  child: Image.asset('assets/pic2.jpg'), // Path to the image you want to overlay
                ),
                SizedBox(height: 20), // Space between the image and text
                Text(
                  'โปรแกรมตรวจจับธนบัตรและเงิน',
                  style: TextStyle(
                    fontSize: 24,
                    color: const Color.fromARGB(255, 0, 0, 0), // Text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20), // Additional space below the text
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'แนะนำแอพ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_outlined),
            label: 'ไปหน้า main.dart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'ไปหน้า member.dart',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
