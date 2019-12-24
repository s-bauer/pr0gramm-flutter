import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/entities/enums/flags.dart';

import 'base_api.dart';

class ProfileApi extends BaseApi {
  Future<ProfileInfo> getProfileInfo({String name, Flags flags}) async {
    final response =
        await client.get("/profile/info?name=$name&flags=${flags.value}");
    return ProfileInfo.fromJson(response.data);
  }
}
