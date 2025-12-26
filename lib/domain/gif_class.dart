class GifClass {
  final String id;
  final String url;
  final String fixedUrl;
  bool isLiked;

  GifClass({
    required this.id,
    required this.url,
    required this.fixedUrl,
    this.isLiked = false,
  });
}
