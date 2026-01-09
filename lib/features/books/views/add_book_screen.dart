import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  Uint8List? _imageBytes;
  bool _isPickingImage = false;
  String? _selectedGenre;
  String? _selectedLanguage;
  final style = const TextStyle(
    color: Color(0xffC1DCFF),
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      8,
      (_) => TextEditingController(),
    );
    _imageController = TextEditingController();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageController.text = 'Image selected';
        });
      }
    } catch (e) {
      AppDialogs.showSnackBar(
        text: "Failed to pick an image: $e",
        context: context,
      );
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  void _clearImage() {
    setState(() {
      _imageBytes = null;
      _imageController.clear();
    });
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
        copiesAvailable: totalCopies,
        coverPictureData: _imageBytes,
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

  // --- BUILD WIDGETS ---

  Widget addBookForm({
    required List<String> genres,
    required List<String> languages,
    required List<TextEditingController> inputControllers,
    required TextStyle textStyle,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImagePicker(),
          const SizedBox(height: 24),
          FormWidgets.formField(
            title: 'Book Title',
            child: AppTextField.customTextField(
              controller: inputControllers[0],
              label: "Enter book title",
              validator: (String? value) => Validator.nameValidator(value),
            ),
          ),
          const SizedBox(height: 16),
          FormWidgets.formField(
            title: 'Author Name',
            child: AppTextField.customTextField(
              controller: inputControllers[1],
              label: "Enter author's name",
              validator: (String? value) => Validator.nameValidator(value),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FormWidgets.formField(
                  title: 'Genre',
                  child: FormWidgets.dropdown(
                    value: _selectedGenre,
                    items: genres,
                    onChanged: (val) => setState(() => _selectedGenre = val),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormWidgets.formField(
                  title: 'Language',
                  child: FormWidgets.dropdown(
                    value: _selectedLanguage,
                    items: languages,
                    onChanged: (val) => setState(() => _selectedLanguage = val),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FormWidgets.formField(
                  title: 'Publish Year',
                  child: AppTextField.customTextField(
                    controller: inputControllers[3],
                    label: "e.g., 2023",
                    validator: (String? value) => Validator.yearValidator(value),
                    keyboardType: TextInputType.number
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormWidgets.formField(
                  title: 'Pages',
                  child: AppTextField.customTextField(
                    controller: inputControllers[5],
                    label: "e.g., 350",
                    validator: (String? value) => Validator.numberValidator(value: value),
                    keyboardType: TextInputType.number
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FormWidgets.formField(
            title: 'Publisher Name',
            child: AppTextField.customTextField(
              controller: inputControllers[4],
              label: "Enter publisher's name",
              validator: (String? value) => Validator.nameValidator(value),
            ),
          ),
          const SizedBox(height: 16),
          FormWidgets.formField(
            title: 'Total Copies',
            child: AppTextField.customTextField(
              controller: inputControllers[7],
              label: "e.g., 10",
              validator: (String? value) => Validator.numberValidator(value: value),
              keyboardType: TextInputType.number
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyButton.secondaryButton(
                  text: 'Cancel',
                  method: _cancel,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: MyButton.primaryButton(
                  text: 'Add Book',
                  method: _submitForm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Book Cover', style: style),
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xff0E1622),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary, width: 1),
              image: _imageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(_imageBytes!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _imageBytes == null
                ? const Center(
                    child: Icon(
                      Icons.book_outlined,
                      color: AppColors.primary,
                      size: 50,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        AppTextField.customTextField(
          isReadOnly: true,
          controller: _imageController,
          label: "Select an image",
          method: _pickImage,
          validator: (value) {
            if (_imageBytes == null) {
              return "Please select a cover image";
            }
            return null;
          },
          prefixIcon: Icon(
            _isPickingImage ? Icons.hourglass_top_rounded : Icons.attach_file,
            color: const Color(0xffC1DCFF),
          ),
          suffixIcon: _imageBytes != null
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.warning),
                  onPressed: _clearImage,
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool noGenres, bool noLanguages) {
    String title;
    String description;
    IconData icon;

    if (noGenres && noLanguages) {
      title = "Missing Categories";
      description = "Genres and Languages are not set up yet. Add them first to create books.";
      icon = Icons.category_outlined;
    } else if (noGenres) {
      title = "No Genres Available";
      description = "Book genres are not set up yet. Add genres first to categorize your books.";
      icon = Icons.local_offer_outlined;
    } else {
      title = "No Languages Available";
      description = "Book languages are not set up yet. Add languages first for better organization.";
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
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withAlpha((0.5 * 255).toInt()),
                      border: Border.all(
                        color: AppColors.background.withAlpha((0.3 * 255).toInt()),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 60,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            shadowColor:
                                AppColors.primary.withAlpha((0.3 * 255).toInt()),
                          ),
                          child: const Row(
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
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back,
                                size: 18, color: AppColors.white),
                            SizedBox(width: 8),
                            Text(
                              'Go Back',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
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
                            const Icon(Icons.lightbulb_outline,
                                color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Quick Tip',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Go to Settings → Categories to add genres and languages. These help organize your library effectively.',
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.4,
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
}
