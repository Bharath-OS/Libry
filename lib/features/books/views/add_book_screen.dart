import 'dart:io';
import 'package:flutter/material.dart';
import 'package:libry/core/utilities/image_services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/styles.dart';
import '../../../core/utilities/helpers.dart' as AppDialogs;
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/text_field.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../data/model/books_model.dart';
import '../viewmodel/book_provider.dart';
import '../../settings/view/settings.dart';

class AddBookScreenView extends StatefulWidget {
  const AddBookScreenView({super.key});

  @override
  State<AddBookScreenView> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreenView> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> controllers;
  late final TextEditingController _imageController;
  String? _temporaryImage;
  bool _isPickingImage = false;
  String? _selectedGenre;
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      8,
          (_) => TextEditingController(),
    ); // Changed from 9 to 8
    _imageController = TextEditingController();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    _imageController.dispose();
    ImageService.cleanupTemporaryImage();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);

    try {
      final tempPath = await ImageService.pickAndSaveTemporaryImage();

      if (tempPath != null) {
        setState(() {
          _temporaryImage = tempPath;
          _imageController.text = 'Image selected';
        });
      }
    } catch (e) {
      AppDialogs.showSnackBar(
        text: "Failed to pick an image.",
        context: context,
      );
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  void _clearImage() {
    setState(() {
      _temporaryImage = null;
      _imageController.clear();
    });
    ImageService.cleanupTemporaryImage();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGenre == null || _selectedGenre!.isEmpty) {
        AppDialogs.showSnackBar(
          text: "Please select a genre",
          context: context,
        );
        return;
      }
      if (_selectedLanguage == null || _selectedLanguage!.isEmpty) {
        AppDialogs.showSnackBar(
          text: "Please select a language",
          context: context,
        );
        return;
      }
      String? imagePath;
      if (_temporaryImage != null) {
        imagePath = await ImageService.makeImagePermanent(_temporaryImage);
        _temporaryImage = null;
      }

      final totalCopies = int.parse(controllers[7].text);

      final book = BookModel(
        title: controllers[0].text.trim(),
        author: controllers[1].text.trim(),
        language: _selectedLanguage!,
        year: controllers[3].text.trim(),
        publisher: controllers[4].text.trim(),
        pages: int.parse(controllers[5].text.trim()),
        genre: _selectedGenre!,
        totalCopies: totalCopies,
        copiesAvailable: totalCopies, // Set to same as totalCopies
        coverPicture: imagePath ?? 'assets/images/dummy_book_cover.png',
      );

      context.read<BookViewModel>().addBook(book);

      Navigator.pop(context);
      AppDialogs.showSnackBar(
        text: "${book.title} successfully added",
        context: context,
      );
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

    // Check if genres or languages are empty
    if (genres.isEmpty || languages.isEmpty) {
      return _buildEmptyState(genres.isEmpty, languages.isEmpty);
    }

    _selectedGenre ??= genres.first;
    _selectedLanguage ??= languages.first;

    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FormWidgets.formContainer(
            title: "Add Book",
            formWidget: addBookForm(
              genres: genres,
              languages: languages,
              inputControllers: controllers,
              textStyle: textStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool noGenres, bool noLanguages) {
    String title;
    String description;
    IconData icon;

    if (noGenres && noLanguages) {
      title = "Missing Categories";
      description = "Genres and Languages are not set up yet.\nAdd them first to create books.";
      icon = Icons.category_outlined;
    } else if (noGenres) {
      title = "No Genres Available";
      description = "Book genres are not set up yet.\nAdd genres first to categorize your books.";
      icon = Icons.local_offer_outlined;
    } else {
      title = "No Languages Available";
      description = "Book languages are not set up yet.\nAdd languages first for better organization.";
      icon = Icons.language_outlined;
    }

    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decorative Container
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withAlpha((0.1*255).toInt()),
                      border: Border.all(
                        color: AppColors.primary.withAlpha((0.3*255).toInt()),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              
                  SizedBox(height: 32),
              
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                    textAlign: TextAlign.center,
                  ),
              
                  SizedBox(height: 16),
              
                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
              
                  SizedBox(height: 40),
              
                  // Action Buttons
                  Column(
                    children: [
                      // Primary Action Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SettingsView()),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            shadowColor: AppColors.primary.withAlpha((0.3*255).toInt()),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Add Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              
                      SizedBox(height: 16),
              
                      // Secondary Action Button
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back, size: 18,color: AppColors.white,),
                            SizedBox(width: 8),
                            Text(
                              'Go Back',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              
                  SizedBox(height: 24),
              
                  // Tips Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightGrey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.orange, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Quick Tip',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Go to Settings → Categories to add genres and languages.\nThese help organize your library effectively.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addBookForm({
    required List<String> genres,
    required List<String> languages,
    required List<TextEditingController> inputControllers,
    required TextStyle textStyle,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Text Fields
            AppTextField.customTextField(
              controller: inputControllers[0],
              label: "Book title",
              maxLength: 20,
              validator: (value) => Validator.emptyValidator(value),
            ),
            AppTextField.customTextField(
              controller: inputControllers[1],
              label: "Author name",
              maxLength: 20,
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
                    dropdownColor: AppColors.darkGrey,
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
              controller: inputControllers[3],
              label: "Publish year",
              keyboardType: TextInputType.number,
              validator: (value) => Validator.yearValidator(value),
            ),
            AppTextField.customTextField(
              controller: inputControllers[4],
              label: "Publisher",
              maxLength: 20,
              validator: (value) => Validator.emptyValidator(value),
            ),
            AppTextField.customTextField(
              controller: inputControllers[5],
              label: "Number of pages",
              keyboardType: TextInputType.number,
              validator: (value) => Validator.numberValidator(value: value),
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
                    dropdownColor: AppColors.darkGrey,
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
              controller: inputControllers[7],
              label: "Total copies",
              keyboardType: TextInputType.number,
              validator: (value) => Validator.numberValidator(value:value),
            ),

            const SizedBox(height: 20),

            // Cover Image Section
            _buildImageSection(textStyle),

            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: MyButton.secondaryButton(
                    method: _cancel,
                    text: "Cancel",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyButton.primaryButton(
                    method: _submitForm,
                    text: "Save",
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
            hintText: "Tap to select cover image",
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
                    tooltip: 'Remove image',
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

        // Image Preview (only if image exists)
        if (_temporaryImage != null)
          Padding(
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
                    File(_temporaryImage!),
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
          ),
      ],
    );
  }
}