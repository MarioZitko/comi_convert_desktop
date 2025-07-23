import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileSelectionWidget extends StatefulWidget {
  const FileSelectionWidget({super.key});

  @override
  State<FileSelectionWidget> createState() => _FileSelectionWidgetState();
}

class _FileSelectionWidgetState extends State<FileSelectionWidget> {
  String selectedFilePath = '';
  bool isLoading = false;

  Future<void> _pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['cbz', 'cbr', 'pdf'],
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.path != null) {
        setState(() {
          selectedFilePath = result.files.single.path!;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Comic/Manga File:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : _pickFile,
          child: isLoading 
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text('Loading...'),
                  ],
                )
              : const Text('Browse Files'),
        ),
        const SizedBox(height: 16),
        Text(
          selectedFilePath.isEmpty 
              ? 'No file selected' 
              : 'Selected: ${selectedFilePath.split('/').last}',
          style: TextStyle(
            color: selectedFilePath.isEmpty ? Colors.grey : Colors.black,
          ),
        ),
        if (selectedFilePath.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Full path: $selectedFilePath',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}