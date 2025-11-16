class UserModel {
  final String name;
  final String email;
  final String? avatar;
  final int orders;

  UserModel({
    required this.name,
    required this.email,
    required this.avatar,
    required this.orders,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      orders: json['orders'] ?? 0,
    );
  }
}
