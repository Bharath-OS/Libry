import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class LayoutWidgets {
  static Widget customScaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    String backgroundImage = 'assets/images/splash_bg_resized.jpg',
  }) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          body,
        ],
      ),
    );
  }

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