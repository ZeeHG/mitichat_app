class AccountInfo {
  String username;
  String password;

  AccountInfo({
    required this.username,
    required this.password,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}
