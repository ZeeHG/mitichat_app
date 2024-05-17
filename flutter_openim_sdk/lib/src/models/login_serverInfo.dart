class ServerInfo {
  String url;

  ServerInfo({required this.url});

  // 从JSON数据创建一个ServerInfo实例
  factory ServerInfo.fromJson(Map<String, dynamic> json) {
    return ServerInfo(
      url: json['url'],
    );
  }

  // 将ServerInfo实例转换成JSON格式
  Map<String, dynamic> toJson() => {
        'url': url,
      };

  // 将ServerInfo实例转换成Map，这通常用于数据库操作等
  Map<String, dynamic> toMap() {
    return {
      'url': url,
    };
  }
}
