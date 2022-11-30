class UserModel {
  late int id;
  final String email;
  final String username;

  UserModel._({required this.email, required this.username});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return new UserModel._(
      email: json['email'],
      username: json['username'],
    );
  }
}
