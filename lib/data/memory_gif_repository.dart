import 'package:gif_imeges_app/domain/favorites_repository.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';

class MemoryGifRepository implements FavoritesRepository {
  static final List<GifClass> favList = [];
  
  @override
  Future<List<GifClass>> fetchFavGifs() {
    return Future.value(List.unmodifiable(favList));
  }
}