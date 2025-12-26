import 'package:gif_imeges_app/domain/gif_class.dart';

abstract class FavoritesRepository {
  Future<List<GifClass>> fetchFavGifs();
}