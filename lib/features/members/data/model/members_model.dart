import 'package:hive/hive.dart';

part 'members_model.g.dart';

@HiveType(typeId: 1)
class MemberModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? memberId;

  @HiveField(3)
  String email;

  @HiveField(4)
  String phone;

  @HiveField(5)
  String address;

  @HiveField(6)
  int totalBorrow;

  @HiveField(7)
  int currentlyBorrow;

  @HiveField(8)
  double fine;

  @HiveField(9)
  DateTime joined;

  @HiveField(10)
  DateTime expiry;

  @HiveField(11)
  double fineBalance;

  MemberModel({
    this.id,
    this.memberId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.totalBorrow = 0,
    this.currentlyBorrow = 0,
    this.fine = 0.0,
    required this.joined,
    required this.expiry,
    this.fineBalance = 0.0, // NEW
  });

  MemberModel copyWith({
    String? id,
    String? name,
    String? memberId,
    String? email,
    String? phone,
    String? address,
    int? totalBorrow,
    int? currentlyBorrow,
    double? fine,
    double? fineBalance,
    DateTime? joined,
    DateTime? expiry,
  }) {
    return MemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      memberId: memberId ?? this.memberId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      totalBorrow: totalBorrow ?? this.totalBorrow,
      currentlyBorrow: currentlyBorrow ?? this.currentlyBorrow,
      fine: fine ?? this.fine,
      fineBalance: fineBalance ?? this.fineBalance,
      joined: joined ?? this.joined,
      expiry: expiry ?? this.expiry,
    );
  }

  // Update member fine balance by amount (positive to add owed fine, negative when paid)
  void adjustFine(double amount) {
    fineBalance = (fineBalance + amount);
    if (fineBalance < 0) fineBalance = 0.0; // keep non-negative
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] as String?,
      memberId: map['member_id'] as String?,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      totalBorrow: map['total_borrow'] as int,
      currentlyBorrow: map['currently_borrow'] as int,
      fine: (map['fine'] as num?)?.toDouble() ?? 0.0,
      joined: DateTime.parse(map['joined_date'] as String),
      expiry: DateTime.parse(map['expiry_date'] as String),
      fineBalance: (map['fineBalance'] as num?)?.toDouble() ?? 0.0, // NEW
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'member_id': memberId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'total_borrow': totalBorrow,
      'currently_borrow': currentlyBorrow,
      'fine': fine,
      'joined_date': joined.toIso8601String(),
      'expiry_date': expiry.toIso8601String(),
      'fineBalance': fineBalance, // NEW
    };
  }
}