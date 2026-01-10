import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

// Claude changed: Simplified ImageService to work with Uint8List for cross-platform compatibility
class ImageService {
  static final ImagePicker _picker = ImagePicker();
  static Uint8List? _temporaryImageBytes; // Track temporary image in memory

  // Claude changed: Pick image and return bytes (works on Android & Web)
  static Future<Uint8List?> pickImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (pickedImage != null) {
        final bytes = await pickedImage.readAsBytes();

        // Store as temporary
        _temporaryImageBytes = bytes;
        return bytes;
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  // Claude changed: Get temporary image bytes
  static Uint8List? getTemporaryImage() {
    return _temporaryImageBytes;
  }

  // Claude changed: Clear temporary image (call on cancel)
  static void clearTemporaryImage() {
    _temporaryImageBytes = null;
  }

  // Claude changed: Confirm image (call on save) - just clears the temp reference
  static void confirmImage() {
    _temporaryImageBytes = null;
  }

  // Claude changed: Helper to display image from bytes or asset
  static ImageProvider getImageProvider(Uint8List? imageBytes, {String? fallbackAsset}) {
    if (imageBytes != null && imageBytes.isNotEmpty) {
      return MemoryImage(imageBytes);
    }
    if (fallbackAsset != null && fallbackAsset.isNotEmpty) {
      return AssetImage(fallbackAsset);
    }
    // Default fallback
    return const AssetImage('assets/images/dummy_book_cover.png');
  }
}