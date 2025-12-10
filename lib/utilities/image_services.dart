import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();
  static String? _temporaryImagePath; // Track temporary images

  static Future<bool> checkImage(String? path) async{
    return await File(path!).exists();
  }

  // Pick and temporarily save image (not permanent yet)
  static Future<String?> pickAndSaveTemporaryImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (pickedImage != null) {
        // Get temp directory
        final tempDir = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'temp_book_cover_$timestamp.jpg';
        final tempPath = '${tempDir.path}/$fileName';

        // Save to temp location
        final tempFile = File(tempPath);
        await tempFile.writeAsBytes(await pickedImage.readAsBytes());

        // Delete previous temp image if exists
        await _deleteTemporaryImage();

        // Store new temp path
        _temporaryImagePath = tempPath;
        return tempPath;
      }
      return null;
    } catch (e) {
      // throw Exception('Error picking image: $e');
      return null;
    }
  }

  // Make temporary image permanent (call this only when saving)
  static Future<String?> makeImagePermanent(String? tempPath) async {
    if (tempPath == null || !await File(tempPath).exists()) {
      return null;
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'book_cover_$timestamp.jpg';
      final permanentPath = '${appDir.path}/$fileName';

      // Copy to permanent location
      final permanentFile = File(permanentPath);
      await permanentFile.writeAsBytes(await File(tempPath).readAsBytes());

      // Delete temporary file
      await File(tempPath).delete();
      _temporaryImagePath = null;

      return permanentPath;
    } catch (e) {
      print('Error making image permanent: $e');
      return null;
    }
  }

  // Clean up temporary image (call on cancel)
  static Future<void> cleanupTemporaryImage() async {
    await _deleteTemporaryImage();
  }

  // Delete old permanent image (call when replacing in edit)
  static Future<void> deletePermanentImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return;

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  // Helper method to delete temporary image
  static Future<void> _deleteTemporaryImage() async {
    if (_temporaryImagePath != null) {
      try {
        final file = File(_temporaryImagePath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error deleting temp image: $e');
      }
      _temporaryImagePath = null;
    }
  }

  // Check if path is a valid image file
  static bool isValidImagePath(String? path) {
    if (path == null || path.isEmpty) return false;
    if (path.startsWith('assets/')) return true; // Default asset image
    return File(path).existsSync();
  }
}