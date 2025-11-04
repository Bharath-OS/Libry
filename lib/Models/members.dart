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
