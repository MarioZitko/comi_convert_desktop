import 'package:flutter/material.dart';
import '../widgets/file_selection_widget.dart';
import '../widgets/conversion_options_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isConverting = false;
  double conversionProgress = 0.0;
  Map<String, dynamic> conversionSettings = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ComiConvert'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Selection Section
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: FileSelectionWidget(),
            ),
            
            const Divider(),
            
            // Conversion Options Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ConversionOptionsWidget(
                onChanged: (settings) {
                  setState(() {
                    conversionSettings = settings;
                  });
                },
              ),
            ),
            
            const Divider(),
            
            // Progress Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (isConverting) ...[
                    LinearProgressIndicator(
                      value: conversionProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    isConverting ? 'Status: Converting...' : 'Status: Ready',
                    style: TextStyle(
                      color: isConverting ? Colors.blue : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Delivery Options Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Options:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement save to computer
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Save to Computer'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement send to Kindle email
                          },
                          icon: const Icon(Icons.email),
                          label: const Text('Send to Kindle'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement connect device
                          },
                          icon: const Icon(Icons.usb),
                          label: const Text('Connect Device'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
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