import 'package:flutter/material.dart';
import 'package:libry/utilities/helpers.dart';

import '../../../themes/styles.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/layout_widgets.dart';
import '../../../database/userdata.dart';
import '../../../models/user_model.dart';
import '../../../widgets/forms.dart';
import '../../utilities/validation.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late User userData;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _booksIssuedController;
  late final TextEditingController _finesController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userData = _getUserData()!;
    _nameController = TextEditingController(text: userData.name);
    _emailController = TextEditingController(text: userData.email);
    _passwordController = TextEditingController(text: userData.password);
    _booksIssuedController = TextEditingController(
      text: userData.bookIssued.toString(),
    );
    _finesController = TextEditingController(
      text: userData.fineCollected.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _booksIssuedController.dispose();
    _finesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(
        barTitle: 'Edit Profile Screen',
        context: context,
      ),
      body: FormWidgets.formContainer(
        title: 'Edit Profile',
        formWidget: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          TextFormField(
            controller: _nameController,
            style: TextFieldStyle.inputTextStyle,
            validator: (value) => Validator.emptyValidator(value),
          ),
          TextFormField(
            controller: _emailController,
            style: TextFieldStyle.inputTextStyle,
            validator: (email) => Validator.emailValidator(email),
          ),
          TextFormField(
            controller: _passwordController,
            style: TextFieldStyle.inputTextStyle,
            validator: (password) => Validator.passwordValidator(password),
          ),
          TextFormField(
            controller: _booksIssuedController,
            style: TextFieldStyle.inputTextStyle,
            validator: (booksCollected) =>
                Validator.emptyValidator(booksCollected),
          ),
          TextFormField(
            controller: _finesController,
            style: TextFieldStyle.inputTextStyle,
            validator: (fines) => Validator.emptyValidator(fines),
          ),
          MyButton.primaryButton(text: 'Save', method: _editUserData),
        ],
      ),
    );
  }

  User? _getUserData() {
    User? user = UserDatabase.getData();
    if (user != null) return user;
    return null;
  }

  void _editUserData() {
    if (_formKey.currentState!.validate()) {
      if (userData.name != _nameController.text ||
          userData.email != _emailController.text ||
          userData.password != _passwordController.text ||
          userData.fineCollected != double.parse(_finesController.text) ||
          userData.bookIssued != int.parse(_booksIssuedController.text)) {
        final updatedUser = User(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          fineCollected: double.parse(_finesController.text),
          bookIssued: int.parse(_booksIssuedController.text),
        );
        final success = UserDatabase.editData(user: updatedUser);
        if (success) {
          showSnackBar(text: "Profile successfully updated", context: context);
          Navigator.pop(context);
        } else {
          showSnackBar(text: "Failed to update profile", context: context);
        }
      } else {
        showSnackBar(text: "No fields changed", context: context);
      }
    }
  }
}
