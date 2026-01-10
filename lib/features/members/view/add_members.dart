import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libry/core/widgets/text_field.dart';
import '../../../core/utilities/helpers.dart' as AppDialogs;
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../viewmodel/members_provider.dart';
import 'package:provider/provider.dart';
import '../data/model/members_model.dart';

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
    controllers = List.generate(4, (_) => TextEditingController());
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final membersProvider = Provider.of<MembersViewModel>(
        context,
        listen: false,
      );

      // Create a new member
      final newMember = MemberModel(
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

      bool success = await membersProvider.addMember(newMember);
      if(success){
        for (var controller in controllers) {
          controller.clear();
        }
      Navigator.pop(context);
      AppDialogs.showSnackBar(
        text: "${newMember.name} successfully added",
        context: context,
      );
      }else{
        AppDialogs.showSnackBar(
          text: "Error adding member: ${newMember.name}",
          context: context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: FormWidgets.formContainer(
              title: "Add Member",
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
        spacing: 10,
        children: [
          AppTextField.customTextField(
            controller: controllers[0],
            label: 'Full Name',
            validator: (value) => Validator.nameValidator(value),
            // maxLength: 24,
          ),
          AppTextField.customTextField(
            controller: controllers[1],
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (email) => Validator.emailValidator(email),
          ),
          AppTextField.customTextField(
            controller: controllers[2],
            label: 'Phone',
            keyboardType: TextInputType.phone,
            validator: (phone) => Validator.phoneValidator(phone),
            maxLength: 10,
          ),
          AppTextField.customTextField(
            controller: controllers[3],
            label: 'Address',
            maxLines: 3,
            validator: (value) => Validator.emptyValidator(value),
          ),
          SizedBox(height: 20.h),
          FormWidgets.formActionButtons(context: context, saveMethod: _submitForm),
        ],
      ),
    );
  }
}
