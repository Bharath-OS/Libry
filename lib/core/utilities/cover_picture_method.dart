import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


Future<String?> pickImage() async{
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if(image != null){
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = "book_cover_${DateTime.now().millisecondsSinceEpoch}";
    final selectedImage = File('${appDir.path}/$fileName');
    await selectedImage.writeAsBytes(await image.readAsBytes());
    return selectedImage.path;
  }
  else{
    return null;
  }
}
