import 'package:flutter/material.dart';

import '../../../themes/styles.dart';
import '../../../Utilities/constants.dart';
import '../../../Widgets/appbar.dart';
import '../../../Widgets/buttons.dart';
import '../../../Widgets/scaffold.dart';
import '../../../database/userdata.dart';
import '../../../models/user.dart';
import '../../../widgets/form.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late User userData;
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userData = _getUserData()!;
    _idController = TextEditingController(text: userData.libId);
    _nameController = TextEditingController(text: userData.name);
    _emailController = TextEditingController(text: userData.email);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: LibryAppBar.appBar(
        barTitle: 'Edit Profile Screen',
        context: context,
      ),
      body: FormContainer(title: 'Edit Profile', formWidget: _buildForm()),
    );
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        spacing: 20,
        children: [
          TextFormField(
            controller: _idController,
            style: TextFieldStyle.inputTextStyle,
          ),
          TextFormField(
            controller: _nameController,
            style: TextFieldStyle.inputTextStyle,
          ),
          TextFormField(
            controller: _emailController,
            style: TextFieldStyle.inputTextStyle,
          ),
          MyButton.primaryButton(text: 'Save', method: () {}),
        ],
      ),
    );
  }

  User? _getUserData() {
    User? user = UserDatabase.getData();
    if (user != null) return user;
    return null;
  }

  _editUserData() {
    if (_formKey.currentState!.validate()) {
      if (userData.libId != _idController.text ||
          userData.name != _nameController.text ||
          userData.email != _emailController.text) {
        UserDatabase.saveData(
          user: User(
            name: _nameController.text,
            email: _emailController.text,
            libId: _idController.text,
          ),
        );
      }
    }
  }
}
