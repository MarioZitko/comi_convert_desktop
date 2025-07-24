import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

/// Service for managing KindleComicConverter (KCC) operations
/// 
/// This service handles the execution of KCC commands by extracting
/// the bundled executable to a temporary location and running it.
class KccService {
  static const String _assetBasePath = 'native_tools/native_executables';
  
  // Cache for the extracted executable path
  String? _cachedExecutablePath;
  
  /// Available device profiles for KCC conversion
  static const List<String> deviceProfiles = [
    'Kindle Paperwhite',
    'Kobo Clara 2E', 
    'Onyx Boox Nova 3',
    'Generic E-reader',
  ];

  /// Determines the correct KCC executable name based on the current platform
  String _getExecutableName() {
    if (Platform.isWindows) {
      return 'run_kcc_windows.exe';
    } else if (Platform.isMacOS) {
      return 'run_kcc_macos';
    } else if (Platform.isLinux) {
      return 'run_kcc_linux';
    } else {
      throw UnsupportedError(
        'Platform ${Platform.operatingSystem} is not supported'
      );
    }
  }

  /// Extracts the KCC executable from assets to a temporary directory
  /// 
  /// Returns the path to the extracted executable
  Future<String> _getExecutablePath() async {
    // Return cached path if available and file still exists
    if (_cachedExecutablePath != null) {
      final cachedFile = File(_cachedExecutablePath!);
      if (await cachedFile.exists()) {
        return _cachedExecutablePath!;
      }
    }

    try {
      final String executableName = _getExecutableName();
      final String assetPath = '$_assetBasePath/$executableName';
      
      if (kDebugMode) {
        print('KccService: Loading executable from asset: $assetPath');
      }

      // Load the executable from assets
      final ByteData executableData = await rootBundle.load(assetPath);
      final Uint8List executableBytes = executableData.buffer.asUint8List();

      // Create directory in Application Support for the executable
      final Directory appSupportDir = Directory(path.join(
        Platform.environment['HOME'] ?? '',
        'Library',
        'Application Support',
        'ComiConvert'
      ));
      
      if (!await appSupportDir.exists()) {
        await appSupportDir.create(recursive: true);
      }
      
      final String executablePath = path.join(appSupportDir.path, executableName);
      
      // Write executable to temporary location
      final File executableFile = File(executablePath);
      await executableFile.writeAsBytes(executableBytes);
      
      // Make file executable on Unix-like systems
      if (!Platform.isWindows) {
        if (kDebugMode) {
          print('KccService: Setting executable permissions for: $executablePath');
        }
        
        final ProcessResult chmodResult = await Process.run('chmod', ['755', executablePath]);
        
        if (chmodResult.exitCode != 0) {
          if (kDebugMode) {
            print('KccService: chmod failed with exit code ${chmodResult.exitCode}');
            print('KccService: chmod stderr: ${chmodResult.stderr}');
          }
          throw FileSystemException(
            'Failed to set executable permissions: ${chmodResult.stderr}',
            executablePath,
          );
        }
        
        if (kDebugMode) {
          print('KccService: Successfully set executable permissions');
          // Verify permissions were set correctly
          final FileStat stat = await executableFile.stat();
          final int mode = stat.mode;
          final bool isExecutable = (mode & 0x49) != 0; // Check owner and group execute bits
          print('KccService: File permissions after chmod: ${mode.toRadixString(8)}');
          print('KccService: Is executable: $isExecutable');
        }
        
        // Try to remove quarantine attribute and codesign issues
        try {
          await Process.run('xattr', ['-d', 'com.apple.quarantine', executablePath]);
          if (kDebugMode) {
            print('KccService: Removed quarantine attribute');
          }
        } catch (e) {
          if (kDebugMode) {
            print('KccService: Could not remove quarantine (may not exist): $e');
          }
        }
      }

      // Cache the path
      _cachedExecutablePath = executablePath;
      
      if (kDebugMode) {
        print('KccService: Executable extracted to: $executablePath');
      }

      return executablePath;
      
    } catch (e) {
      if (kDebugMode) {
        print('KccService: Error extracting executable: $e');
      }
      throw FileSystemException(
        'Failed to extract KCC executable: $e',
        _getExecutableName(),
      );
    }
  }

  /// Builds command arguments for KCC conversion
  List<String> _buildKccArguments({
    required String inputPath,
    required String outputPath,
    String deviceProfile = 'Kindle Paperwhite',
    bool mangaMode = false,
    bool upscale = false,
    bool noMargin = false,
  }) {
    final List<String> args = [inputPath, outputPath];
    
    // Add device profile
    args.addAll(['--device', deviceProfile]);
    
    // Add optional flags
    if (mangaMode) args.add('--manga-mode');
    if (upscale) args.add('--upscale');
    if (noMargin) args.add('--no-margin');
    
    return args;
  }

  /// Runs a KCC conversion process
  /// 
  /// [inputPath] - Path to the input comic file
  /// [outputPath] - Path for the output file
  /// [deviceProfile] - Target device profile
  /// [mangaMode] - Enable manga reading mode
  /// [upscale] - Enable image upscaling
  /// [noMargin] - Disable margins
  /// 
  /// Returns the stdout output from the KCC process
  /// Throws [FileSystemException] if executable cannot be found or extracted
  /// Throws [ProcessException] if the KCC process fails
  /// Throws [ArgumentError] for invalid arguments
  Future<String> runConversion({
    required String inputPath,
    required String outputPath,
    String deviceProfile = 'Kindle Paperwhite',
    bool mangaMode = false,
    bool upscale = false,
    bool noMargin = false,
  }) async {
    // Validate device profile
    if (!deviceProfiles.contains(deviceProfile)) {
      throw ArgumentError(
        'Invalid device profile: $deviceProfile. '
        'Supported profiles: ${deviceProfiles.join(', ')}'
      );
    }

    try {
      // Get executable path (extracts if needed)
      final String executablePath = await _getExecutablePath();
      
      // Build command arguments
      final List<String> commandArgs = _buildKccArguments(
        inputPath: inputPath,
        outputPath: outputPath,
        deviceProfile: deviceProfile,
        mangaMode: mangaMode,
        upscale: upscale,
        noMargin: noMargin,
      );

      if (kDebugMode) {
        print('KccService: Executing: $executablePath ${commandArgs.join(' ')}');
      }

      // Execute the KCC command
      if (kDebugMode) {
        print('KccService: About to execute with Process.run()');
        print('KccService: Working directory: ${Directory.current.path}');
      }
      
      final ProcessResult result = await Process.run(
        executablePath,
        commandArgs,
        workingDirectory: Directory.current.path,
      );

      // Check process exit code
      if (result.exitCode != 0) {
        final String errorMessage = 'KCC process failed with exit code ${result.exitCode}';
        final String stderr = result.stderr.toString().trim();
        
        if (kDebugMode) {
          print('KccService: $errorMessage');
          if (stderr.isNotEmpty) {
            print('KccService: stderr: $stderr');
          }
        }
        
        throw ProcessException(
          executablePath,
          commandArgs,
          stderr.isNotEmpty ? '$errorMessage: $stderr' : errorMessage,
          result.exitCode,
        );
      }

      final String output = result.stdout.toString();
      
      if (kDebugMode) {
        print('KccService: Conversion completed successfully');
      }

      return output;

    } on FileSystemException {
      rethrow;
    } on ProcessException {
      rethrow;
    } on ArgumentError {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('KccService: Unexpected error: $e');
      }
      throw Exception('KCC conversion failed: $e');
    }
  }

  /// Runs a dummy KCC conversion for testing purposes
  /// 
  /// Uses default dummy file paths and the provided conversion settings
  Future<String> runDummyConversion({
    String deviceProfile = 'Kindle Paperwhite',
    bool mangaMode = false,
    bool upscale = false,
    bool noMargin = false,
  }) async {
    return runConversion(
      inputPath: 'dummy_input.cbz',
      outputPath: 'dummy_output.epub',
      deviceProfile: deviceProfile,
      mangaMode: mangaMode,
      upscale: upscale,
      noMargin: noMargin,
    );
  }

  /// Runs KCC conversion with file validation
  /// 
  /// Validates that the input file exists and has a supported extension
  /// before running the conversion
  Future<String> runFileConversion({
    required String inputPath,
    required String outputPath,
    String deviceProfile = 'Kindle Paperwhite',
    bool mangaMode = false,
    bool upscale = false,
    bool noMargin = false,
  }) async {
    // Validate input file exists
    final File inputFile = File(inputPath);
    if (!await inputFile.exists()) {
      throw FileSystemException(
        'Input file does not exist',
        inputPath,
      );
    }

    // Validate file extension
    final String extension = path.extension(inputPath).toLowerCase();
    const List<String> supportedExtensions = ['.cbz', '.cbr', '.pdf', '.zip', '.rar'];
    
    if (!supportedExtensions.contains(extension)) {
      throw ArgumentError(
        'Unsupported file type: $extension. '
        'Supported types: ${supportedExtensions.join(', ')}'
      );
    }

    return runConversion(
      inputPath: inputPath,
      outputPath: outputPath,
      deviceProfile: deviceProfile,
      mangaMode: mangaMode,
      upscale: upscale,
      noMargin: noMargin,
    );
  }

  /// Gets the list of available device profiles
  List<String> getAvailableDeviceProfiles() {
    return List.unmodifiable(deviceProfiles);
  }

  /// Cleans up cached resources
  /// 
  /// Should be called when the service is no longer needed
  Future<void> dispose() async {
    if (_cachedExecutablePath != null) {
      try {
        final File cachedFile = File(_cachedExecutablePath!);
        
        // Only delete the specific executable file, not the entire directory
        // since we're now using Application Support which may contain other files
        if (await cachedFile.exists()) {
          await cachedFile.delete();
        }
        
        _cachedExecutablePath = null;
        
        if (kDebugMode) {
          print('KccService: Cleaned up cached executable');
        }
      } catch (e) {
        if (kDebugMode) {
          print('KccService: Error cleaning up cache: $e');
        }
      }
    }
  }
}