import 'package:flutter/material.dart';
import '../../../core/utilities/helpers.dart';
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/text_field.dart';
import '../data/model/user_model.dart';
import '../data/services/userdata.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserModel userData;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userData = _getUserData()!;
    _nameController = TextEditingController(text: userData.name);
    _emailController = TextEditingController(text: userData.email);
    _passwordController = TextEditingController(text: userData.password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
          AppTextField.customTextField(
            label: "Name",
            controller: _nameController,
            validator: (value) => Validator.emptyValidator(value),
          ),
          AppTextField.customTextField(
            label: "Email",
            controller: _emailController,
            validator: (email) => Validator.emailValidator(email),
          ),
          AppTextField.customTextField(
            label: "Password",
            controller: _passwordController,
            validator: (password) => Validator.passwordValidator(password),
          ),
          FormWidgets.formActionButtons(context: context, saveMethod: _editUserData),
        ],
      ),
    );
  }

  UserModel? _getUserData() {
    UserModel? user = UserModelService.getData();
    if (user != null) return user;
    return null;
  }

  void _editUserData() {
    if (_formKey.currentState!.validate()) {
      if (userData.name != _nameController.text ||
          userData.email != _emailController.text ||
          userData.password != _passwordController.text) {
        final updatedUser = UserModel(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final success = UserModelService.editData(user: updatedUser);
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
