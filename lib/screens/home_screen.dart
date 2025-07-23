import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ComiConvert'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Comic/Manga File:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement file picker functionality
              },
              child: const Text('Browse Files'),
            ),
            const SizedBox(height: 16),
            Text(
              selectedFilePath.isEmpty 
                  ? 'No file selected' 
                  : 'Selected: $selectedFilePath',
              style: TextStyle(
                color: selectedFilePath.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Conversion Options:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.arrow_drop_down, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Device Profile (Dropdown)', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_box_outline_blank, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Manga Mode (Checkbox)', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_box_outline_blank, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Upscale (Checkbox)', style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_box_outline_blank, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('No Margin (Checkbox)', style: TextStyle(color: Colors.orange)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}