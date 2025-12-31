import '../../../../core/constants/app_colors.dart';
import '../../../../core/utilities/validation.dart';
import '../../../../core/widgets/text_field.dart';
import 'package:flutter/material.dart';

class BookFormView extends StatefulWidget {
  final List<TextEditingController> inputControllers;
  const BookFormView({super.key,required this.inputControllers});

  @override
  State<BookFormView> createState() => _BookFormViewState();
}

class _BookFormViewState extends State<BookFormView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

}




