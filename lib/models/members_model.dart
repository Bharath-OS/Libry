class Members {
  int? id;
  String name;
  String memberId;
  String email;
  String phone;
  String address;
  int totalBorrow;
  int currentlyBorrow;
  double fine;
  DateTime joined;
  DateTime expiry;

  Members({
    this.id,
    required this.name,
    required this.memberId,
    required this.email,
    required this.phone,
    required this.address,
    required this.totalBorrow,
    required this.currentlyBorrow,
    required this.fine,
    required this.joined,
    required this.expiry,
  });
}

class MembersKey{
  static const String id = 'id'; // Add this
  static const String name = 'name';
  static const String memberId = "member_id"; // Use snake_case for SQL
  static const String email = 'email';
  static const String phone = "phone";
  static const String address = "address";
  static const String totalBorrow = 'total_borrow';
  static const String currentlyBorrow = "currently_borrow";
  static const String fine = 'fine';
  static const String joined = "joined_date";
  static const String expiry = "expiry_date";
}
