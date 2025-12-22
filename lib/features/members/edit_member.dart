import 'package:flutter/material.dart';
import 'package:libry/Themes/styles.dart';
import '../../constants/app_colors.dart';
import '../../utilities/validation.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/forms.dart';
import '../../widgets/layout_widgets.dart';
import '../../provider/members_provider.dart'; // You'll need this
import 'package:provider/provider.dart'; // You'll need this
import '../../models/members_model.dart'; // You'll need this

class EditMembersScreen extends StatefulWidget {
  final Members member;
  const EditMembersScreen({super.key, required this.member});

  @override
  State<EditMembersScreen> createState() => _EditMembersScreenState();
}

class _EditMembersScreenState extends State<EditMembersScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> controllers;

  @override
  initState() {
    super.initState();
    controllers = List.generate(4, (_) => TextEditingController());
    controllers[0].text = widget.member.name;
    controllers[1].text = widget.member.email;
    controllers[2].text = widget.member.phone;
    controllers[3].text = widget.member.address;
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
      final membersProvider = Provider.of<MembersProvider>(
        context,
        listen: false,
      );

      // Create a new member
      final updatedMember = Members(
        id: widget.member.id,
        memberId: widget.member.memberId,
        name: controllers[0].text.trim(),
        email: controllers[1].text.trim(),
        phone: controllers[2].text.trim(),
        address: controllers[3].text.trim(),
        totalBorrow: widget.member.totalBorrow,
        currentlyBorrow: widget.member.currentlyBorrow,
        fine: widget.member.fine,
        joined: widget.member.joined,
        expiry: widget.member.expiry,
      );

      membersProvider.updateMember(updatedMember);
      Navigator.pop(context);
      AppDialogs.showSnackBar(
        message: "${updatedMember.name} updated successfully",
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FormWidgets.formContainer(
              title: "Edit Member",
              formWidget: _editMemberForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _editMemberForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          TextFormField(
            controller: controllers[0],
            style: TextFieldStyle.inputTextStyle,
            decoration: InputDecoration(
              labelText: 'Full Name',
              labelStyle: TextFieldStyle.inputTextStyle,
            ),
            validator: (value) => Validator.emptyValidator(value),
          ),
          TextFormField(
            controller: controllers[1],
            style: TextFieldStyle.inputTextStyle,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (email) => Validator.emailValidator(email),
          ),
          TextFormField(
            controller: controllers[2],
            style: TextFieldStyle.inputTextStyle,
            decoration: InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
            validator: (phone) => Validator.phoneValidator(phone),
          ),
          TextFormField(
            controller: controllers[3],
            style: TextFieldStyle.inputTextStyle,
            decoration: InputDecoration(labelText: 'Address'),
            maxLines: 3,
            validator: (value) => Validator.emptyValidator(value),
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
                  child: Text('Edit Member'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
