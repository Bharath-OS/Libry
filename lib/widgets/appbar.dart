import 'package:flutter/material.dart';

import '../Utilities/constants.dart';

class LibryAppBar {
  static AppBar appBar({required String barTitle,required BuildContext context}) {
    return AppBar(
      title: Text(
        barTitle,
        style: TextStyle(
          color: MyColors.whiteBG,
          fontFamily: "Livvic",
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new)),
    );
  }
}
