import 'package:hive/hive.dart';

part 'user_model.g.dart';
@HiveType(typeId: 0)
class UserModel{
  @HiveField(0)
  String name;
  @HiveField(1)
  String email;
  @HiveField(2)
  String password;
  @HiveField(3)
  int bookIssued;
  @HiveField(4)
  double fineCollected;

  UserModel({
    required this.name,
    required this.email,
    this.password = "",
    this.bookIssued = 0,
    this.fineCollected = 0.0,
  });
}

late Box userDataBox;
late Box userDataBoxNew;
late Box statusBox;
