import 'package:flutter/material.dart';
import '../widgets/file_selection_widget.dart';
import '../widgets/conversion_options_widget.dart';
import '../services/kcc_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isConverting = false;
  double conversionProgress = 0.0;
  ConversionSettings? _conversionSettings;
  
  final KccService _kccService = KccService();
  bool _isLoading = false;
  String _kccOutput = '';

  Future<void> _runKccDummy() async {
    setState(() {
      _isLoading = true;
      _kccOutput = '';
    });

    try {
      final String output = await _kccService.runDummyConversion(
        deviceProfile: _conversionSettings?.deviceProfile ?? 'Kindle Paperwhite',
        mangaMode: _conversionSettings?.mangaMode ?? false,
        upscale: _conversionSettings?.upscale ?? false,
        noMargin: _conversionSettings?.noMargin ?? false,
      );
      
      setState(() {
        _kccOutput = output;
      });
    } catch (e) {
      setState(() {
        _kccOutput = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up KCC service resources
    _kccService.dispose();
    super.dispose();
  }

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
                    _conversionSettings = settings;
                  });
                },
              ),
            ),
            
            const Divider(),
            
            // KCC Test Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KCC Test:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Run KCC Dummy Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _runKccDummy,
                      icon: _isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.play_arrow),
                      label: Text(_isLoading ? 'Running KCC...' : 'Run KCC Dummy'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // KCC Output Display
                  if (_kccOutput.isNotEmpty) ...[
                    const Text(
                      'KCC Output:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _kccOutput.startsWith('Error:') 
                            ? Colors.red[50] 
                            : Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _kccOutput.startsWith('Error:') 
                              ? Colors.red[300]! 
                              : Colors.green[300]!,
                        ),
                      ),
                      child: Text(
                        _kccOutput,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: _kccOutput.startsWith('Error:') 
                              ? Colors.red[800] 
                              : Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ],
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