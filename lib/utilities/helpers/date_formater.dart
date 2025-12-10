import 'package:intl/intl.dart';

String dateFormat({required DateTime date,String format = 'EEEE d, MMM y'}){
  var formatter = DateFormat(format);
  return formatter.format(date);
}