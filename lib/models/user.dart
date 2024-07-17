class User {
  String userId;
  String email;
  String? imageUrl;
  String fullName;
  DateTime birthday;
  String phoneNumber;
  String address;
  String role;
  bool isAvailable;
  bool isEnable;
  bool isUnlocked;
  DateTime createdDate;
  DateTime updatedDate;
  String? modifiedBy;
  String? createdBy;

  User({
    required this.userId,
    required this.email,
    this.imageUrl,
    required this.fullName,
    required this.birthday,
    required this.phoneNumber,
    required this.address,
    required this.role,
    required this.isAvailable,
    required this.isEnable,
    required this.isUnlocked,
    required this.createdDate,
    required this.updatedDate,
    this.modifiedBy,
    this.createdBy,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      fullName: json['fullName'],
      birthday: DateTime.parse(json['birthday']),
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      role: json['role'],
      isAvailable: json['isAvailable'],
      isEnable: json['isEnable'],
      isUnlocked: json['isUnlocked'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      modifiedBy: json['modifiedBy'],
      createdBy: json['createdBy'],
    );
  }
}
