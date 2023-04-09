import 'dart:io';

import 'package:memerly/mastodon.dart';
import 'package:memerly/memer.dart';

final accessToken = Platform.environment['accessToken'] ?? '';
final mastodonInstance = const String.fromEnvironment('mastodonInstance',
    defaultValue: 'https://mastodon.social');

void main() {
  if (accessToken.isEmpty) throw 'No token provided';

  final mastodon = Mastodon(
    instance: mastodonInstance,
    accessToken: accessToken,
  );

  final memer = Memer();

  print("Starting...");
  memer.meming(polling: Duration(hours: 1)).listen(mastodon.postMeme);
}
