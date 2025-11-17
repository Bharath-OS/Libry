import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:libry/constants/app_colors.dart';

FloatingActionButton fab({required VoidCallback method}) {
  return FloatingActionButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    backgroundColor: MyColors.primaryButtonColor,
    elevation: 0,
    onPressed: method,
    child: Icon(Icons.add, color: MyColors.whiteBG, size: 40),
  );
}
