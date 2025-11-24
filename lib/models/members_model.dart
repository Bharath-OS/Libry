class Members {
  String name;
  String memberId;
  String email;
  String phone;
  String dob;
  String address;
  int totalBorrow;
  int currentlyBorrow;
  int fine;
  String joined;
  String expiry;

  Members({
    required this.name,
    required this.memberId,
    required this.email,
    required this.phone,
    required this.dob,
    required this.address,
    required this.totalBorrow,
    required this.currentlyBorrow,
    required this.fine,
    required this.joined,
    required this.expiry,
  });
}

class MembersKey{
  static const String name = 'name';
  static const String memberId = "members id";
  static const String email = 'email';
  static const String phone = "phone";
  static const String dob = 'date of birth';
  static const String address = "address";
  static const String totalBorrow = 'total books borrowed';
  static const String currentlyBorrow = "currently borrowed books";
  static const String fine = 'fine owed';
  static const String joined = "joined date";
  static const String expiry = "expiry date";
}
