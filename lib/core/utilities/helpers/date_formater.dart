import 'package:intl/intl.dart';

String dateFormat({required DateTime date,String format = 'MMM dd yyyy'}){
  var formatter = DateFormat(format);
  return formatter.format(date);
}