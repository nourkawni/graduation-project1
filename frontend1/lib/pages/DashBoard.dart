import 'package:flutter/material.dart';
import 'package:frontend1/pages/home_page.dart'; // Import the correct page
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? email;

  @override
  void initState() {
    super.initState();
    _retrieveEmail();
  }
var id;
  Future<void> _retrieveEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // Decode the token to get the email
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        email = decodedToken['email'];
      });
      id=decodedToken['_id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Align contents to the start
          children: [
            Image.asset(
              'lib/images/R.png', // Replace with your image path
              width: 50.0, // Image width
              height: 50.0, // Image height
            ),
            SizedBox(width: 4.0), // Space between image and text
            Text(
              email ?? 'Loading...', // Display email or loading text
              style: TextStyle(
                fontSize: 14.0, // Adjust text size
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 26.0, left: 20.0, bottom: 20),
            child: Text(
              'Jump back in',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[350],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Horizontal scrolling
              child: Row(
                children: [
                  squareItem(Icons.add_a_photo_rounded, 'Pics'),
                  squareItem(Icons.library_books, 'Books'),
                  squareItem(Icons.live_tv, 'TV'),
                  squareItem(Icons.library_music_rounded, 'Music'),
                  squareItem(Icons.info, 'Info'),
                  squareItem(Icons.contact_mail, 'Contact'),
                  squareItem(Icons.list_alt_outlined, 'To do List'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _createNoteAndNavigate(context); // Trigger note creation and navigation
              },
              icon: Icon(Icons.add),
              label: Text('Add Item'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Button color
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                rectangleItem(Icons.add_a_photo_rounded, 'Pics'),
                rectangleItem(Icons.library_books, 'Books'),
                rectangleItem(Icons.live_tv, 'TV'),
                rectangleItem(Icons.library_music_rounded, 'Music'),
                rectangleItem(Icons.info, 'Info'),
                rectangleItem(Icons.contact_mail, 'Contact'),
                rectangleItem(Icons.list_alt_outlined, 'To do List'),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.browse_gallery), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          // Handle tap events here
        },
      ),
    );
  }

  Future<void> _createNoteAndNavigate(BuildContext context) async {
    final url = 'http://192.168.1.94:3000/add-default-note'; // Replace with your backend URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 201) {
        final noteData = jsonDecode(response.body)['note'];
         final userId = id; // Replace with the actual user ID you want to use
         print("user id is");
         print(userId);
    final noteId = noteData; // Replace with the actual note ID you want to add
    final url = 'http://192.168.1.94:3000/push-note/$userId'; // URL with userId

    try {
        final response = await http.put(
            Uri.parse(url),
            headers: {
                'Content-Type': 'application/json',
            },
            body: jsonEncode({
                'noteId': noteId, // The note ID to be added to the user
            }),
        );

        if (response.statusCode == 200) {
            final updatedUserData = jsonDecode(response.body);
            // Optionally navigate or update UI based on the updated user data
            print('Note added to user successfully: ${updatedUserData['user']}');
             Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(note: noteData),
          ),
        );
        } else {
            print('Failed to add note to user');
        }
    } catch (error) {
        print('Error: $error');
    }

       
      } else {
        print('Failed to add note');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}

Widget squareItem(IconData icon, String title) {
  return Container(
    width: 100.0,
    height: 100.0,
    margin: EdgeInsets.symmetric(horizontal: 8.0),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 45, 63, 78),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 25.0),
        SizedBox(height: 10.0),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      ],
    ),
  );
}

Widget rectangleItem(IconData icon, String title) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 45, 63, 78),
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          spreadRadius: 2.0,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: 30.0),
        SizedBox(width: 20.0),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ],
    ),
  );
}
