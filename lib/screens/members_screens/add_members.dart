import 'package:flutter/material.dart';

import '../../widgets/forms.dart';
import '../../widgets/layout_widgets.dart';

class AddMembersScreen extends StatefulWidget {
  const AddMembersScreen({super.key});

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> controllers;
  @override
  initState() {
    super.initState();
    controllers = List.generate(9, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FormWidgets.formContainer(
            title: "Add Book",
            formWidget: _addMemberForm(context),
          ),
        ),
      ),
    );
  }

  Widget _addMemberForm(BuildContext context) {
    void back() {
      Navigator.pop(context);
    }

    return Form(child: TextFormField());
  }

}
