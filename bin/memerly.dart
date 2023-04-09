import 'package:memerly/mastodon.dart';
import 'package:memerly/memer.dart';


const accessToken = String.fromEnvironment('accessToken', defaultValue: '');
const mastodonInstance = String.fromEnvironment('mastodonInstance',
    defaultValue: 'https://mastodon.social');

void main() {
  if (accessToken.isEmpty) throw 'No token provided';

  final mastodon = Mastodon(
    instance: mastodonInstance,
    accessToken: accessToken,
  );

  final memer = Memer();

  memer.meming(polling: Duration(seconds: 10)).listen(mastodon.postMeme);
}
