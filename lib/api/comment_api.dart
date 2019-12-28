import 'package:dio/dio.dart';
import 'package:pr0gramm/api/base_api.dart';

import '../entities/enums/vote.dart';


class CommentApi extends BaseApi {
  Future vote(int commentId, Vote vote, String nonce) async {
    final data = {
      "id": commentId,
      "vote": vote.value,
      "_nonce": nonce,
    };

    await client.post(
      "/comments/vote",
      data: data,
      options: new Options(contentType: Headers.formUrlEncodedContentType),
    );
  }
}