import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // You'll need this
import '../../../core/constants/app_colors.dart';
import '../../../core/utilities/helpers.dart' as AppDialogs;
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/text_field.dart';
import '../viewmodel/members_provider.dart';
import '../data/model/members_model.dart';

class EditMembersScreen extends StatefulWidget {
  final MemberModel member;
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
      final membersProvider = Provider.of<MembersViewModel>(
        context,
        listen: false,
      );

      // Create a new member
      final updatedMember = MemberModel(
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
        text: "${updatedMember.name} updated successfully",
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
          AppTextField.customTextField(
            controller: controllers[0],
            label: "Name",
            validator: (value) => Validator.emptyValidator(value),
            maxLength: 24
          ),
          AppTextField.customTextField(
            controller: controllers[1],
            label: "Email",
            keyboardType: TextInputType.emailAddress,
            validator: (email) => Validator.emailValidator(email),
          ),
          AppTextField.customTextField(
            controller: controllers[2],
            label: 'Phone',
            keyboardType: TextInputType.phone,
            validator: (phone) => Validator.phoneValidator(phone),
            maxLength: 10
          ),
          AppTextField.customTextField(
            controller: controllers[3],
            label: 'Address',
            maxLines: 3,
            validator: (value) => Validator.emptyValidator(value),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryButton,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButton,
                    foregroundColor: AppColors.white,
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
