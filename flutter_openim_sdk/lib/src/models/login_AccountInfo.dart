class AccountInfo {
  String username;
  String password;

  AccountInfo({required this.username, required this.password});

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccountInfo &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode;
}
