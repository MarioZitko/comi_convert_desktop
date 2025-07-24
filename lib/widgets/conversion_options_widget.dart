import 'package:flutter/material.dart';
import '../services/kcc_service.dart';

/// Configuration data for conversion options
class ConversionSettings {
  final String deviceProfile;
  final bool mangaMode;
  final bool upscale;
  final bool noMargin;

  const ConversionSettings({
    required this.deviceProfile,
    required this.mangaMode,
    required this.upscale,
    required this.noMargin,
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceProfile': deviceProfile,
      'mangaMode': mangaMode,
      'upscale': upscale,
      'noMargin': noMargin,
    };
  }
}

/// Widget for configuring comic conversion options
class ConversionOptionsWidget extends StatefulWidget {
  final void Function(ConversionSettings)? onChanged;
  
  const ConversionOptionsWidget({
    super.key,
    this.onChanged,
  });

  @override
  State<ConversionOptionsWidget> createState() => _ConversionOptionsWidgetState();
}

class _ConversionOptionsWidgetState extends State<ConversionOptionsWidget> {
  late final List<String> _deviceProfiles;
  String _selectedDeviceProfile = 'Kindle Paperwhite';
  bool _mangaMode = false;
  bool _upscale = false;
  bool _noMargin = false;

  @override
  void initState() {
    super.initState();
    // Get device profiles from KCC service
    _deviceProfiles = KccService.deviceProfiles;
    // Notify with initial values after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyChange();
    });
  }

  void _notifyChange() {
    final settings = ConversionSettings(
      deviceProfile: _selectedDeviceProfile,
      mangaMode: _mangaMode,
      upscale: _upscale,
      noMargin: _noMargin,
    );
    widget.onChanged?.call(settings);
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
            value: _selectedDeviceProfile,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            items: _deviceProfiles.map((String profile) {
              return DropdownMenuItem<String>(
                value: profile,
                child: Text(profile),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedDeviceProfile = newValue;
                });
                _notifyChange();
              }
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        CheckboxListTile(
          title: const Text('Manga Mode'),
          value: _mangaMode,
          onChanged: (bool? value) {
            setState(() {
              _mangaMode = value ?? false;
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
          value: _upscale,
          onChanged: (bool? value) {
            setState(() {
              _upscale = value ?? false;
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
          value: _noMargin,
          onChanged: (bool? value) {
            setState(() {
              _noMargin = value ?? false;
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