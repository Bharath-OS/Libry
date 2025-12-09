import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libry/widgets/alert_dialogue.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/books_model.dart';
import '../../provider/book_provider.dart';
import '../../provider/genre_provider.dart';
import '../../provider/language_provider.dart';
import '../../utilities/image_services.dart';
import '../../utilities/validation.dart';
import '../../widgets/forms.dart';
import '../../widgets/layout_widgets.dart';

class EditBookScreen extends StatefulWidget {
  final Books book;
  const EditBookScreen({super.key, required this.book});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> controllers;
  late final TextEditingController _imageController;
  late Books _book;
  String? _temporaryImage;
  bool _isPickingImage = false;
  String? _selectedGenre;
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    controllers = List.generate(9, (_) => TextEditingController());
    _imageController = TextEditingController();

    // Initialize form
    controllers[0].text = _book.title;
    controllers[1].text = _book.author;
    _selectedLanguage = _book.language;
    controllers[3].text = _book.year;
    controllers[4].text = _book.publisher;
    controllers[5].text = _book.pages.toString();
    _selectedGenre = _book.genre;
    controllers[7].text = _book.totalCopies.toString();
    controllers[8].text = _book.copiesAvailable.toString();

    // Set image text
    if (_book.coverPicture.isNotEmpty &&
        ImageService.isValidImagePath(_book.coverPicture)) {
      _imageController.text = 'Current cover image';
    }
  }

  @override
  void dispose() {
    ImageService.cleanupTemporaryImage();
    for (var controller in controllers) {
      controller.dispose();
    }
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);

    try {
      final tempPath = await ImageService.pickAndSaveTemporaryImage();

      if (tempPath != null) {
        setState(() {
          _temporaryImage = tempPath;
          _imageController.text = 'New image selected';
        });
      }
    } catch (e) {
      showAlertMessage(message: "Falied to pick Image", context: context);
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  void _clearImage() {
    setState(() {
      _temporaryImage = null;
      if (_book.coverPicture.isNotEmpty) {
        _imageController.text = 'Current cover image';
      } else {
        _imageController.clear();
      }
    });
    ImageService.cleanupTemporaryImage();
  }

  void _saveBook() async{
    if (_formKey.currentState!.validate()) {
      // Use new image if selected, otherwise keep original
      String imagePath = _book.coverPicture;
      if (_temporaryImage != null) {
        final permanentPath = await ImageService.makeImagePermanent(_temporaryImage);
        if(permanentPath != null){
          if(_book.coverPicture.isNotEmpty && !_book.coverPicture.startsWith('assets/') && await ImageService.checkImage(_book.coverPicture)){
            await ImageService.deletePermanentImage(_book.coverPicture);
          }
          imagePath = permanentPath;
        }
      }

      final updatedBook = Books(
        id: _book.id,
        title: controllers[0].text.trim(),
        author: controllers[1].text.trim(),
        language: _selectedLanguage!,
        year: controllers[3].text.trim(),
        publisher: controllers[4].text.trim(),
        pages: int.parse(controllers[5].text),
        genre: _selectedGenre!,
        totalCopies: int.parse(controllers[7].text),
        copiesAvailable: int.parse(controllers[8].text),
        coverPicture: imagePath,
      );

      context.read<BookProvider>().updateBook(updatedBook);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Book updated successfully')));
    }
  }

  void _cancel() {
    // Delete new image if user cancels
    // if (_temporaryImage != null && _temporaryImage!.existsSync()) {
    //   _temporaryImage!.delete();
    // }
    ImageService.cleanupTemporaryImage();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      color: Color(0xffC1DCFF),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    List<String> genres = context.watch<GenreProvider>().getGenre;
    List<String> languages = context.watch<LanguageProvider>().getLanguages;

    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FormWidgets.formContainer(
            title: "Edit Book",
            formWidget: _editBookForm(context, textStyle, genres, languages),
          ),
        ),
      ),
    );
  }

  Widget _editBookForm(
    BuildContext context,
    TextStyle textStyle,
    List<String> genres,
    List<String> languages,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField(
              controller: controllers[0],
              label: "Book title",
              validator: (value) => Validator.emptyValidator(value),
            ),
            _buildTextField(
              controller: controllers[1],
              label: "Author name",
              validator: (value) => Validator.emptyValidator(value),
            ),
            //Language dropdown
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Language",
                  labelStyle: textStyle.copyWith(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    isExpanded: true,
                    style: textStyle,
                    items: languages.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
            _buildTextField(
              controller: controllers[3],
              label: "Publish year",
              validator: (value) => Validator.yearValidator(value),
            ),
            _buildTextField(
              controller: controllers[4],
              label: "Publisher",
              validator: (value) => Validator.emptyValidator(value),
            ),
            _buildTextField(
              controller: controllers[5],
              label: "Number of pages",
              keyboardType: TextInputType.number,
              validator: (value) => Validator.numberValidator(value),
            ),
            //genre dropdown
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Genre",
                  labelStyle: textStyle.copyWith(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGenre,
                    isExpanded: true,
                    style: textStyle,
                    items: genres.map((String genre) {
                      return DropdownMenuItem<String>(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGenre = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
            _buildTextField(
              controller: controllers[7],
              label: "Total copies",
              keyboardType: TextInputType.number,
              validator: (value) => Validator.numberValidator(value),
            ),
            _buildTextField(
              controller: controllers[8],
              label: "Available copies",
              keyboardType: TextInputType.number,
              validator: (value) =>
                  Validator.copiesValidator(value, controllers[7].text),
            ),

            const SizedBox(height: 20),

            // Image Section
            _buildImageSection(textStyle),

            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.secondaryButtonColor,
                      foregroundColor: MyColors.whiteBG,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _cancel,
                    child: Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryButtonColor,
                      foregroundColor: MyColors.whiteBG,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _saveBook,
                    child: Text("Save Changes"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
  }) {
    final textStyle = const TextStyle(
      color: Color(0xffC1DCFF),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        style: textStyle,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: textStyle.copyWith(fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildImageSection(TextStyle textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cover Image", style: textStyle.copyWith(fontSize: 14)),
        const SizedBox(height: 8),

        // Image Picker Field
        TextFormField(
          style: textStyle,
          controller: _imageController,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Tap to change cover image",
            hintStyle: textStyle.copyWith(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: _isPickingImage
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        MyColors.primaryButtonColor,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_temporaryImage != null)
                        IconButton(
                          onPressed: _clearImage,
                          icon: Icon(Icons.clear, color: Colors.red),
                          tooltip: 'Remove new image',
                        ),
                      IconButton(
                        onPressed: _pickImage,
                        icon: Icon(Icons.photo_library),
                        tooltip: 'Pick from gallery',
                      ),
                    ],
                  ),
          ),
          onTap: _isPickingImage ? null : _pickImage,
        ),

        // Show either new image preview or current image path
        if (_temporaryImage != null)
          _buildImagePreview(_temporaryImage!)
        else if (_book.coverPicture.isNotEmpty && ImageService.isValidImagePath(_book.coverPicture))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "Current image: ${_book.coverPicture.split('/').last}",
              style: textStyle.copyWith(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildImagePreview(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: Container(
          height: 150,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, size: 40),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
