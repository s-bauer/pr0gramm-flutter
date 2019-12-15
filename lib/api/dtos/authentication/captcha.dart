import 'dart:convert';
import 'dart:typed_data';

class Captcha {
  static final _b64 = Base64Decoder();

  final String token;
  final Uint8List captchaBytes;

  String captchaResult;

  static String _cleanB64(String input) {
    return input.replaceFirst("data:image/png;base64,", "");
  }

  Captcha({this.token, String captcha})
      : captchaBytes = _b64.convert(_cleanB64(captcha));

  factory Captcha.fromJson(Map<String, dynamic> json) {
    return Captcha(
      token: json["token"],
      captcha: json["captcha"],
    );
  }
}
