import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utilities/helpers.dart' as AppDialogs;
import '../../../core/utilities/image_services.dart';
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/text_field.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../data/model/books_model.dart';
import '../viewmodel/book_provider.dart';


class EditBookScreenView extends StatefulWidget {
  final Books book;
  const EditBookScreenView({super.key, required this.book});

  @override
  State<EditBookScreenView> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreenView> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> controllers;
  late final TextEditingController _imageController;
  late Books _book;
  String? _temporaryImage;
  bool _isPickingImage = false;
  String? _selectedGenre;
  String? _selectedLanguage;

  // Track original values
  late int _originalTotalCopies;
  late int _originalCopiesAvailable;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    controllers = List.generate(8, (_) => TextEditingController()); // Changed from 9 to 8
    _imageController = TextEditingController();

    // Store original values
    _originalTotalCopies = _book.totalCopies;
    _originalCopiesAvailable = _book.copiesAvailable;

    // Initialize form
    controllers[0].text = _book.title;
    controllers[1].text = _book.author;
    _selectedLanguage = _book.language;
    controllers[3].text = _book.year;
    controllers[4].text = _book.publisher;
    controllers[5].text = _book.pages.toString();
    _selectedGenre = _book.genre;
    controllers[7].text = _book.totalCopies.toString();
    // REMOVED: controllers[8] for copiesAvailable

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
      AppDialogs.showSnackBar(text: "Failed to pick Image", context: context);
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
      final newTotalCopies = int.parse(controllers[7].text);

      // Calculate how many copies are currently borrowed
      final currentlyBorrowed = _originalTotalCopies - _originalCopiesAvailable;

      // Calculate new available copies
      final newCopiesAvailable = newTotalCopies - currentlyBorrowed;

      // Validate that new total isn't less than borrowed
      if (newCopiesAvailable < 0) {
        AppDialogs.showSnackBar(
          text: "Total copies cannot be less than currently borrowed copies ($currentlyBorrowed)",
          context: context,
        );
        return;
      }

      // Use new image if selected, otherwise keep original
      String imagePath = _book.coverPicture;
      if (_temporaryImage != null) {
        final permanentPath = await ImageService.makeImagePermanent(_temporaryImage);
        if(permanentPath != null){
          if(_book.coverPicture.isNotEmpty && !_book.coverPicture.startsWith('assets/') && await ImageService.checkImage(_book.coverPicture)){
            await ImageService.deletePermanentImage(_book.coverPicture);
          }
          imagePath = permanentPath;
          _temporaryImage = null;
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
        totalCopies: newTotalCopies,
        copiesAvailable: newCopiesAvailable, // Calculated automatically
        coverPicture: imagePath,
      );

      context.read<BookViewModel>().updateBook(updatedBook);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Book updated successfully')));
    }
  }

  void _cancel() {
    ImageService.cleanupTemporaryImage();
    _temporaryImage = null;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      color: Color(0xffC1DCFF),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    List<String> genres = context.watch<SettingsViewModel>().genres;
    List<String> languages = context.watch<SettingsViewModel>().languages;

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
    final currentlyBorrowed = _originalTotalCopies - _originalCopiesAvailable;

    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField.customTextField(
              controller: controllers[0],
              label: "Book title",
              validator: (value) => Validator.emptyValidator(value),
            ),
            AppTextField.customTextField(
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
            AppTextField.customTextField(
              controller: controllers[3],
              label: "Publish year",
              keyboardType: TextInputType.number,
              validator: (value) => Validator.yearValidator(value),
            ),
            AppTextField.customTextField(
              controller: controllers[4],
              label: "Publisher",
              validator: (value) => Validator.emptyValidator(value),
            ),
            AppTextField.customTextField(
              controller: controllers[5],
              label: "Number of pages",
              keyboardType: TextInputType.number,
              validator: (value) => Validator.numberValidator(value:value),
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
            AppTextField.customTextField(
              controller: controllers[7],
              label: "Total copies",
              keyboardType: TextInputType.number,
              validator: (value) {
                final error = Validator.numberValidator(value:value);
                if (error != null) return error;

                final newTotal = int.tryParse(value ?? '0') ?? 0;
                if (newTotal < currentlyBorrowed) {
                  return "Total cannot be less than borrowed ($currentlyBorrowed)";
                }
                return null;
              },
            ),

            // Show info about currently borrowed copies
            if (currentlyBorrowed > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withAlpha((0.3*255).toInt())),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Currently borrowed: $currentlyBorrowed",
                          style: textStyle.copyWith(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      backgroundColor: AppColors.secondaryButton,
                      foregroundColor: AppColors.white,
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
                      backgroundColor: AppColors.primaryButton,
                      foregroundColor: AppColors.white,
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
                  AppColors.primaryButton,
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