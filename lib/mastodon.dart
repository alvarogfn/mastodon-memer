import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';
import 'package:memerly/models/meme.dart';

class Mastodon {
  final String instance;
  final String accessToken;
  final client = http.Client();

  Mastodon({required this.instance, required this.accessToken});

  String get _url {
    return '$instance/api/v1';
  }

  Future<http.Response> writeInTimeline(Map<String, Object> body) async {
    return client.post(
      Uri.parse('$_url/statuses'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> mediaInTimeline(
    String imageURL,
    Map<String, Object> body,
  ) async {
    final imageResponse = await _postImageFromURL(imageURL);

    final Map<String, dynamic> responseData = jsonDecode(imageResponse.body);

    return writeInTimeline({
      ...body,
      'media_ids': [responseData['id']]
    });
  }

  Future<http.Response> _postImageFromURL(String url) async {
    final image = await client.get(Uri.parse(url));

    final imageContentType = image.headers['content-type']?.split('/');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$instance/api/v2/media'),
    );

    final multipartFile = http.MultipartFile.fromBytes(
      'file',
      image.bodyBytes,
      contentType: imageContentType != null
          ? MediaType(imageContentType[0], imageContentType[1])
          : null,
      filename: 'image.jpeg',
    );

    request.files.add(multipartFile);

    request.headers['Authorization'] = 'Bearer $accessToken';

    return http.Response.fromStream(await request.send());
  }

  Future<http.Response> postMeme(Meme meme) async {
    final imageResponse = await _postImageFromURL(meme.url);
    final imageResponseMap = jsonDecode(imageResponse.body);

    String status = '${meme.title}\n\n${meme.postLink}';

    status += "\n\n\n #meme #funny #bot #reddit";

    if (meme.nsfw) status += ' #NSFW';

    return writeInTimeline({
      'status': status,
      'spoiler': meme.spoiler,
      'sensitive': meme.nsfw,
      'media_ids': [imageResponseMap['id']],
    });
  }
}
