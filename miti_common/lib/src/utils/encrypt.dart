import 'package:encrypt/encrypt.dart';
import 'package:miti_common/miti_common.dart';

String encrypt(String text) {
  final key = Key.fromUtf8(Config.aesKey);
  final iv = IV.fromUtf8(Config.aesIv);
  final encrypter = Encrypter(AES(key));
  return encrypter.encrypt(text, iv: iv).base64;
}

String decrypt(String text) {
  final key = Key.fromUtf8(Config.aesKey);
  final iv = IV.fromUtf8(Config.aesIv);
  final encrypter = Encrypter(AES(key));
  return encrypter.decrypt(Encrypted.fromBase64(text), iv: iv);
}
