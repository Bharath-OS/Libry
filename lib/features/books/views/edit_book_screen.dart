import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/styles.dart';
import '../../../core/utilities/helpers.dart' as AppDialogs;
import '../../../core/utilities/image_services.dart';
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/text_field.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../data/model/books_model.dart';
import '../viewmodel/book_provider.dart';

class EditBookScreenView extends StatefulWidget {
  final BookModel book;
  const EditBookScreenView({super.key, required this.book});

  @override
  State<EditBookScreenView> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreenView> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> controllers;
  late final TextEditingController _imageController;

  // Claude changed: Track original and new image bytes
  Uint8List? _originalImageBytes; // Original image from database
  Uint8List? _newImageBytes; // Newly selected image
  bool _imageCleared = false; // Track if user intentionally cleared image

  bool _isPickingImage = false;
  String? _selectedGenre;
  String? _selectedLanguage;

  late int _originalTotalCopies;
  late int _originalCopiesAvailable;

  final style = const TextStyle(
    color: Color(0xffC1DCFF),
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  @override
  void initState() {
    super.initState();
    controllers = List.generate(8, (_) => TextEditingController());
    _imageController = TextEditingController();

    _originalTotalCopies = widget.book.totalCopies;
    _originalCopiesAvailable = widget.book.copiesAvailable;

    // Claude changed: Store original image
    _originalImageBytes = widget.book.coverPictureData;

    // Initialize form fields
    controllers[0].text = widget.book.title;
    controllers[1].text = widget.book.author;
    _selectedLanguage = widget.book.language;
    controllers[3].text = widget.book.year;
    controllers[4].text = widget.book.publisher;
    controllers[5].text = widget.book.pages.toString();
    _selectedGenre = widget.book.genre;
    controllers[7].text = widget.book.totalCopies.toString();

    if (_originalImageBytes != null) {
      _imageController.text = 'Current cover image';
    }
  }

  @override
  void dispose() {
    // Claude changed: Clean up temporary image on dispose
    ImageService.clearTemporaryImage();

    for (var controller in controllers) {
      controller.dispose();
    }
    _imageController.dispose();
    super.dispose();
  }

  // Claude changed: Simplified image picking
  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);

    try {
      final bytes = await ImageService.pickImage();

      if (bytes != null) {
        setState(() {
          _newImageBytes = bytes;
          _imageCleared = false;
          _imageController.text = 'New image selected';
        });
      }
    } catch (e) {
      if (mounted) {
        AppDialogs.showSnackBar(
          text: "Failed to pick an image: $e",
          context: context,
        );
      }
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  // Claude changed: Clear image (removes both original and new)
  void _clearImage() {
    setState(() {
      _newImageBytes = null;
      _imageCleared = true;
      _imageController.clear();
    });
    ImageService.clearTemporaryImage();
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      final newTotalCopies = int.parse(controllers[7].text);
      final currentlyBorrowed = _originalTotalCopies - _originalCopiesAvailable;
      final newCopiesAvailable = newTotalCopies - currentlyBorrowed;

      if (newCopiesAvailable < 0) {
        AppDialogs.showSnackBar(
          text: "Total copies cannot be less than currently borrowed copies ($currentlyBorrowed)",
          context: context,
        );
        return;
      }

      // Claude changed: Determine final image bytes
      Uint8List? finalImageBytes;
      if (_imageCleared) {
        // User cleared the image intentionally
        finalImageBytes = null;
      } else if (_newImageBytes != null) {
        // User selected a new image
        finalImageBytes = _newImageBytes;
      } else {
        // Keep original image
        finalImageBytes = _originalImageBytes;
      }

      final bookToUpdate = widget.book.copyWith(
        title: controllers[0].text.trim(),
        author: controllers[1].text.trim(),
        language: _selectedLanguage!,
        year: controllers[3].text.trim(),
        publisher: controllers[4].text.trim(),
        pages: int.parse(controllers[5].text),
        genre: _selectedGenre!,
        totalCopies: newTotalCopies,
        copiesAvailable: newCopiesAvailable,
        coverPictureData: finalImageBytes,
      );

      context.read<BookViewModel>().updateBook(bookToUpdate);

      // Claude changed: Confirm image changes
      ImageService.confirmImage();

      if (mounted) {
        Navigator.pop(context);
        AppDialogs.showSnackBar(
          text: 'Book updated successfully',
          context: context,
        );
      }
    }
  }

  void _cancel() {
    // Claude changed: Clean up temporary image on cancel
    ImageService.clearTemporaryImage();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> genres = context.watch<SettingsViewModel>().genres;
    List<String> languages = context.watch<SettingsViewModel>().languages;

    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FormWidgets.formContainer(
            title: "Edit Book",
            formWidget: _editBookForm(context, genres, languages),
          ),
        ),
      ),
    );
  }

  Widget _editBookForm(
      BuildContext context,
      List<String> genres,
      List<String> languages,
      ) {
    final currentlyBorrowed = _originalTotalCopies - _originalCopiesAvailable;

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
              controller: controllers[0],
              label: "Enter book title",
              validator: (String? value) => Validator.nameValidator(value),
            ),
          ),
          const SizedBox(height: 16),
          FormWidgets.formField(
            title: 'Author Name',
            child: AppTextField.customTextField(
              controller: controllers[1],
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
                    controller: controllers[3],
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
                    controller: controllers[5],
                    label: "e.g., 350",
                    validator: (String? value) => Validator.numberValidator(value: value),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FormWidgets.formField(
            title: 'Publisher Name',
            child: AppTextField.customTextField(
              controller: controllers[4],
              label: "Enter publisher's name",
              validator: (String? value) => Validator.nameValidator(value),
            ),
          ),
          const SizedBox(height: 16),
          FormWidgets.formField(
            title: 'Total Copies',
            child: AppTextField.customTextField(
              controller: controllers[7],
              label: "e.g., 10",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter total copies";
                }
                final newTotal = int.tryParse(value);
                if (newTotal == null || newTotal < 1) {
                  return "Must be at least 1";
                }
                if (newTotal < currentlyBorrowed) {
                  return "Cannot be less than borrowed ($currentlyBorrowed)";
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
          ),
          if (currentlyBorrowed > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '$currentlyBorrowed copies are currently on loan.',
                style: const TextStyle(color: AppColors.lightGrey, fontSize: 12),
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
                  text: 'Save Changes',
                  method: _saveBook,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Claude changed: Updated image picker with proper display logic
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
              image: _buildImage(),
            ),
            child: _buildImage() == null
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
          prefixIcon: Icon(
            _isPickingImage ? Icons.hourglass_top_rounded : Icons.attach_file,
            color: const Color(0xffC1DCFF),
          ),
          suffixIcon: (_newImageBytes != null || (!_imageCleared && _originalImageBytes != null))
              ? IconButton(
            icon: const Icon(Icons.clear, color: AppColors.warning),
            onPressed: _clearImage,
          )
              : null,
            validator: null
            // validator: (value) {
            //   if (_imageBytes == null) {
            //     return "Please select a cover image";
            //   }
            //   return null;
            // },
        ),
      ],
    );
  }

  // Claude changed: Build image with proper priority (new > original > none)
  DecorationImage? _buildImage() {
    if (_imageCleared) {
      // User intentionally cleared the image
      return null;
    }

    if (_newImageBytes != null) {
      // Show newly selected image
      return DecorationImage(
        image: MemoryImage(_newImageBytes!),
        fit: BoxFit.cover,
      );
    }

    if (_originalImageBytes != null) {
      // Show original image
      return DecorationImage(
        image: MemoryImage(_originalImageBytes!),
        fit: BoxFit.cover,
      );
    }

    return null;
  }
}