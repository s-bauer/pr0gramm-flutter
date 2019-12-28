import 'package:pr0gramm/api/dtos/comment/profile_comment_batch.dart';
import 'package:pr0gramm/api/dtos/profile_info.dart';
import 'package:pr0gramm/entities/enums/flags.dart';

import 'base_api.dart';

class ProfileApi extends BaseApi {
  Future<ProfileInfo> getProfileInfo({String name, Flags flags}) async {
    final response = await client.get("/profile/info?name=$name&flags=${flags.value}");
    return ProfileInfo.fromJson(response.data);
  }

  Future<ProfileCommentBatch> getProfileCommentBatch({
    String name,
    Flags flags,
    int beforeCreated
  }) async {
    final query = "name=$name&flags=${flags.value}&before=$beforeCreated";
    final response = await client.get("/profile/comments?$query");
    return ProfileCommentBatch.fromJson(response.data);
  }
}
