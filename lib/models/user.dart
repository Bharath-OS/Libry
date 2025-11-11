import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User{
  @HiveField(0)
  String name;
  @HiveField(1)
  String libId;
  @HiveField(2)
  String email;
  @HiveField(3)
  String password;
  @HiveField(4)
  int bookIssued;
  @HiveField(5)
  int fineCollected;

  User({
    required this.name,
    required this.libId,
    required this.email,
    this.password = "",
    this.bookIssued = 0,
    this.fineCollected = 0,
  });
}

late Box userDataBox;
late Box statusBox;
