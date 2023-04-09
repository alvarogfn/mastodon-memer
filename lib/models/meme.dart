class Meme {
  final String url;
  final bool nsfw;
  final bool spoiler;
  final String postLink;
  final String author;
  final String title;

  const Meme({
    required this.url,
    required this.nsfw,
    required this.spoiler,
    required this.postLink,
    required this.author,
    required this.title,
  });

  factory Meme.fromMap(Map<String, dynamic> data) {
    return Meme(
      author: data['author'] as String,
      nsfw: data['nsfw'] as bool,
      spoiler: data['spoiler'] as bool,
      url: data['url'] as String,
      postLink: data['postLink'] as String,
      title: data['title'] as String,
    );
  }
}
