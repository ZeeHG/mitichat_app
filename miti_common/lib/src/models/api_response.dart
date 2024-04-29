import 'dart:convert';

class ApiResponse {
  int errCode;
  String errMsg;
  String errDlt;
  dynamic data;

  ApiResponse.fromJson(Map<String, dynamic> map)
      : errCode = map["errCode"] ?? -1,
        errMsg = map["errMsg"] ?? '',
        errDlt = map["errDlt"] ?? '',
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['errCode'] = errCode;
    data['errMsg'] = errMsg;
    data['errDlt'] = errDlt;
    data['data'] = data;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class ApiError {
  static String getMsg(int errorCode) {
    return _errorZH['$errorCode'] ?? '';
  }

  static const _errorZH = {
    '10001': '请求参数错误',
    '10002': '数据库错误',
    '10003': '服务器错误',
    '10006': '记录不存在',
    '20001': '账号已注册',
    '20002': '重复发送验证码',
    '20003': '邀请码错误',
    '20004': '注册IP受限',
    '30001': '验证码错误',
    '30002': '验证码已过期',
    '30003': '邀请码被使用',
    '30004': '邀请码不存在',
    '40001': '账号未注册',
    '40002': '密码错误',
    '40003': '登录受ip限制',
    '40004': 'ip禁止注册登录',
    '50001': '过期',
    '50002': '格式错误',
    '50003': '未生效',
    '50004': '未知错误',
    '50005': '创建错误',
  };
  static const _errorEN = {
    '10001': 'Request parameter error',
    '10002': 'Database error',
    '10003': 'Server error',
    '10006': 'Record does not exist',
    '20001': 'Account already registered',
    '20002': 'Duplicate verification code sent',
    '20003': 'Invitation code is incorrect',
    '20004': 'Registration IP restricted',
    '30001': 'Verification code incorrect',
    '30002': 'Verification code expired',
    '30003': 'Invitation code used',
    '30004': 'Invitation code does not exist',
    '40001': 'Account not registered',
    '40002': 'Password incorrect',
    '40003': 'Login restricted by IP',
    '40004': 'IP banned from registering or logging in',
    '50001': 'Expired',
    '50002': 'Format error',
    '50003': 'Not effective',
    '50004': 'Unknown error',
    '50005': 'Creation error',
  };
}
