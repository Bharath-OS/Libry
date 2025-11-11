import 'package:flutter/material.dart';

import 'package:libry/constants/app_colors.dart';

FloatingActionButton fab(VoidCallback method) {
  return FloatingActionButton(
    onPressed: method,
    child: Icon(Icons.add, color: MyColors.whiteBG),
  );
}
