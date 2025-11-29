import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

spacing({required double height}) {
  return SizedBox(height: height);
}
void showSnackBar({required String text,required BuildContext context}){
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(text)));
}

PageTransition transition({required Widget child}){
  return PageTransition(
    type: PageTransitionType.fade,
    curve: Curves.easeIn,
    child: child,
    duration: Duration(milliseconds: 300),
  );
}
Future<String?> pickAndSaveImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    // Get app documents directory
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'book_cover_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = File('${appDir.path}/$fileName');

    // Copy the image to app directory
    await savedImage.writeAsBytes(await image.readAsBytes());

    return savedImage.path; // This path will persist
  }
  return null;
}