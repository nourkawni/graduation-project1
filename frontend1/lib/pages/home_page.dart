import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> note;

  const HomePage({Key? key, required this.note}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showButtons = false;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _titleController =
      TextEditingController(text: 'New page');
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      _saveChangesToBackend();
    });
  }

  Future<void> _saveChangesToBackend() async {
    final url = 'http://192.168.1.86:3000/edit-note/${widget.note['_id']}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': _titleController.text,
          'text': _controller.text,
        }),
      );
      if (response.statusCode == 201) {
        print('Changes saved successfully');
      } else {
        print('Failed to save changes');
      }
    } catch (error) {
      print('Error saving changes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        titleSpacing: 0,
        title: TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:2.0,left:20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                print("Add icon clicked");
              },
              child: Row(
                children: [
                  const Icon(Icons.add, color: Colors.grey), // Add icon
                  const SizedBox(width: 5), // Spacing between icon and text
                  const Text(
                    'Add icon',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0),
            if (showButtons)
              Row(
                children: [
                  TextButton(onPressed: () {}, child: const Text('Add icon')),
                  TextButton(onPressed: () {}, child: const Text('Add cover')),
                  TextButton(onPressed: () {}, child: const Text('Add comment')),
                ],
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showButtons = !showButtons;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 40),
                  decoration: InputDecoration(
                    hintText: 'New page',
                    hintStyle: TextStyle(
                      fontSize: 40,
                      color: Colors.grey[400],
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
            ),
            const Spacer(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 245, 243, 243),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Ask AI',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 245, 243, 243),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Draft anything',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 245, 243, 243),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Templates',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
