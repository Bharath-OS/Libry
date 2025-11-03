import 'package:flutter/material.dart';

import '../Utilities/constants.dart';

class LibryAppBar {
  static AppBar appBar({required String barTitle}) {
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
      leading: Icon(Icons.arrow_back_ios_new),
    );
  }
}
