import 'package:flutter/material.dart';

class ConversionOptionsWidget extends StatefulWidget {
  final Function(Map<String, dynamic>)? onChanged;
  
  const ConversionOptionsWidget({
    super.key,
    this.onChanged,
  });

  @override
  State<ConversionOptionsWidget> createState() => _ConversionOptionsWidgetState();
}

class _ConversionOptionsWidgetState extends State<ConversionOptionsWidget> {
  final List<String> deviceProfiles = [
    'Kindle Paperwhite',
    'Kobo Clara 2E',
    'Onyx Boox Nova 3',
    'Generic E-reader',
  ];
  
  String selectedDeviceProfile = 'Kindle Paperwhite';
  bool mangaMode = false;
  bool upscale = false;
  bool noMargin = false;

  void _notifyChange() {
    if (widget.onChanged != null) {
      widget.onChanged!({
        'deviceProfile': selectedDeviceProfile,
        'mangaMode': mangaMode,
        'upscale': upscale,
        'noMargin': noMargin,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: DropdownButton<String>(
            value: selectedDeviceProfile,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            items: deviceProfiles.map((String profile) {
              return DropdownMenuItem<String>(
                value: profile,
                child: Text(profile),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedDeviceProfile = newValue;
                });
                _notifyChange();
              }
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        CheckboxListTile(
          title: const Text('Manga Mode'),
          value: mangaMode,
          onChanged: (bool? value) {
            setState(() {
              mangaMode = value ?? false;
            });
            _notifyChange();
          },
          activeColor: Colors.blue,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          tileColor: Colors.blue[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.blue[200]!),
          ),
        ),
        
        const SizedBox(height: 12),
        
        CheckboxListTile(
          title: const Text('Upscale'),
          value: upscale,
          onChanged: (bool? value) {
            setState(() {
              upscale = value ?? false;
            });
            _notifyChange();
          },
          activeColor: Colors.green,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          tileColor: Colors.green[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.green[200]!),
          ),
        ),
        
        const SizedBox(height: 12),
        
        CheckboxListTile(
          title: const Text('No Margin'),
          value: noMargin,
          onChanged: (bool? value) {
            setState(() {
              noMargin = value ?? false;
            });
            _notifyChange();
          },
          activeColor: Colors.orange,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          tileColor: Colors.orange[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.orange[200]!),
          ),
        ),
      ],
    );
  }
}