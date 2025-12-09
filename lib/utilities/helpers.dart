import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

spacing({required double height}) {
  return SizedBox(height: height);
}
void showSnackBar({required String text,required BuildContext context}){
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(text)));
}

PageTransition transition({required Widget child}){
  return PageTransition(
    type: PageTransitionType.fade,
    curve: Curves.easeIn,
    child: child,
    duration: Duration(milliseconds: 300),
  );
}

String dateFormat({required DateTime date,String format = 'EEEE d, MMM y'}){
  var formatter = DateFormat(format);
  return formatter.format(date);
}