import 'package:flutter/material.dart';
import 'package:libry/Themes/styles.dart';
import '../../constants/app_colors.dart';
import '../../widgets/alert_dialogue.dart';
import '../../widgets/forms.dart';
import '../../widgets/layout_widgets.dart';
import '../../provider/members_provider.dart'; // You'll need this
import 'package:provider/provider.dart'; // You'll need this
import '../../models/members_model.dart'; // You'll need this

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
    super.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final membersProvider = Provider.of<MembersProvider>(context, listen: false);

      // Create a new member
      final newMember = Members(
        name: controllers[0].text,
        email: controllers[1].text,
        phone: controllers[2].text,
        address: controllers[3].text,
        totalBorrow: 0,
        currentlyBorrow: 0,
        fine: 0.0,
        joined: DateTime.now(),
        expiry: DateTime.now().add(Duration(days: 365)), // 1 year membership
      );

      membersProvider.addMember(newMember);
      Navigator.pop(context);
      showAlertMessage(message: "${newMember.name} successfully added", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FormWidgets.formContainer(
              title: "Add Book",
              formWidget: _addMemberForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addMemberForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          TextFormField(
            controller: controllers[0],
            style: TextFieldStyle.inputTextStyle,
            decoration: InputDecoration(labelText: 'Full Name', labelStyle: TextFieldStyle.inputTextStyle),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: controllers[1],
            style: TextFieldStyle.inputTextStyle,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            controller: controllers[2],
            style: TextFieldStyle.inputTextStyle,
            decoration: InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
          ),
          TextFormField(
            controller: controllers[3],
            style: TextFieldStyle.inputTextStyle,
            decoration: InputDecoration(labelText: 'Address'),
            maxLines: 3,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.secondaryButtonColor,
                    foregroundColor: MyColors.whiteBG,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryButtonColor,
                    foregroundColor: MyColors.whiteBG,
                  ),
                  onPressed: _submitForm,
                  child: Text('Add Member'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}