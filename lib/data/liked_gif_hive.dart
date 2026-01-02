import 'package:hive/hive.dart';

class LikedGifEntity extends HiveObject {
  final String id;
  final String url;
  final String fixedUrl;

  LikedGifEntity({required this.id, required this.url, required this.fixedUrl});
}
