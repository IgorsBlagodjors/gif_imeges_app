import 'package:gif_imeges_app/domain/gif_class.dart';

abstract class FavoritesRepository {
  Future<Set<String>> likedIds();
  Stream<List<GifClass>> watchFavGifs();

  Future<void> like(GifClass gif);
  Future<void> unlike(String id);
}