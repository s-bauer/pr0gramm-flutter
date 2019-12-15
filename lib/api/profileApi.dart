import 'package:pr0gramm/api/dtos/profileInfoResponse.dart';
import 'package:pr0gramm/entities/enums/flags.dart';

import 'baseApi.dart';

class ProfileApi extends BaseApi {
  Future<ProfileInfoResponse> getProfileInfo({String name, Flags flags}) async {
    final response = await client.get("/profile/info?name=$name&flags=${flags.value}");
    return ProfileInfoResponse.fromJson(response.data);
  }
}