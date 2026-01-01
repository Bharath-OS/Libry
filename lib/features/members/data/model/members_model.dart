class MemberModel {
  int? id;
  String name;
  String? memberId;
  String email;
  String phone;
  String address;
  int totalBorrow;
  int currentlyBorrow;
  double fine;
  DateTime joined;
  DateTime expiry;

  MemberModel({
    this.id,
    this.memberId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.totalBorrow,
    required this.currentlyBorrow,
    required this.fine,
    required this.joined,
    required this.expiry,
  });

  MemberModel copyWith({
    int? id,
    String? name,
    String? memberId,
    String? email,
    String? phone,
    String? address,
    int? totalBorrow,
    int? currentlyBorrow,
    double? fine,
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
      joined: joined ?? this.joined,
      expiry: expiry ?? this.expiry,
    );
  }
}

class MembersKey{
  static const String id = 'id';
  static const String name = 'name';
  static const String memberId = "member_id";
  static const String email = 'email';
  static const String phone = "phone";
  static const String address = "address";
  static const String totalBorrow = 'total_borrow';
  static const String currentlyBorrow = "currently_borrow";
  static const String fine = 'fine';
  static const String joined = "joined_date";
  static const String expiry = "expiry_date";
}