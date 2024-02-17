import 'dart:convert';
import 'dart:io';
import 'package:assignment/Api/api_service.dart';
import 'package:assignment/ThemeChange/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:assignment/widget/CustomEditText.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;
  final controller = ScrollController();
  List<dynamic> _items = [];
  bool _hasmore = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future<void> fetch() async {
    if (isLoading) return;
    try {
      isLoading = true;
      const limit = 10;

      final List<dynamic> newItems = await ApiService.fetchData(page: page, limit: limit);

      setState(() {
        page++;
        isLoading = false;
        if (newItems.length < limit) {
          _hasmore = false;
        }
        _items.addAll(newItems);
      });
    } catch (e) {
      // Handle network failure or other exceptions
      if (e is SocketException) {
        showErrorMessage('Failed to connect to the server. Please check your internet connection.');
      } else {
        // Handle other exceptions
        print('Error: $e');
        showErrorMessage('An unexpected error occurred. Please try again later.');
      }
    } finally {
      // Ensure isLoading is set to false even in case of an error
      isLoading = false;
    }
  }

  void showErrorMessage(String message) {
    // Display a dialog or a snackbar with the error message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Fetching'),
        actions: [
          IconButton(onPressed: (){
            currentTheme.switchTheme();}, icon: const Icon(Icons.lightbulb_outline)),
        ],
      ),
      body: ListView.builder(
          controller: controller,
          padding: EdgeInsets.all(8),
          itemCount: _items.length + 1,
          itemBuilder: (context, index) {
            if (index < _items.length) {
              final Map<String, dynamic> item = _items[index];
              final id = item['id'].toString();
              final title = item['title'].toString();
              final description = item['description'].toString();
              final image_url = item['image_url'].toString();

              return Card(
                shadowColor: Colors.amber,
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const  LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF212130),
                        Color(0xFF39304A)
                      ], // Adjust the colors as needed
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: item['image_url'] != null
                        ? Image.network(
                            item['image_url'],
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.5,
                            fit: BoxFit.values.last,
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey,
                            child: const Text('Image Loading....'),
                          ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomEditText(text: id,),
                        const SizedBox(height: 8), // Add some spacing
                        CustomEditText(text: title),
                        const SizedBox(height: 8), // Add some spacing
                       CustomEditText(text: description),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: _hasmore
                      ? const CircularProgressIndicator()
                      : const Text('No more Data to Load'),
                ),
              );
            }
          }),
    );
  }
}
