import 'package:dio/dio.dart';
import 'package:pr0gramm/api/dtos/profileInfoResponse.dart';

import 'baseApi.dart';
import 'dtos/LoginResponse.dart';
import 'dtos/captcha.dart';

class ProfileApi extends BaseApi {
  Future<ProfileInfoResponse> getProfileInfo({String name, int flags}) async {
    final response = await client.get("/profile/info?name=$name&flags=$flags");
    return ProfileInfoResponse.fromJson(response.data);
  }
}