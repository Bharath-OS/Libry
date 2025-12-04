import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Picker Example")),
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 200)
                : Text("No image selected."),
            ElevatedButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text("Pick from Gallery"),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Take a Photo"),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSelection {
  static Future<String?> pickImage() async {
    final _picker = ImagePicker();

    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Good quality with compression
      maxWidth: 800, // Limit size for performance
    );

    if (pickedImage != null) {
      // Get app's documents directory for permanent storage
      final appDir = await getApplicationDocumentsDirectory();

      // Create unique filename using timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'book_cover_$timestamp.jpg';
      final permanentPath = '${appDir.path}/$fileName';

      // Create File object for the new location
      final savedImage = File(permanentPath);

      // Read original image bytes
      final imageBytes = await pickedImage.readAsBytes();

      // Write bytes to permanent location
      await savedImage.writeAsBytes(imageBytes);

      // Update UI state
      return savedImage.path;
    }
    return null;
  }
}
