import 'package:gif_imeges_app/data/hive_database_client.dart';
import 'package:gif_imeges_app/domain/favorites_repository.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';

class MemoryGifRepository implements FavoritesRepository {
  final HiveDatabaseClient _hive;

  MemoryGifRepository( this._hive);

  @override
  Future<void> like(GifClass gif) {
    return _hive.like(gif);
  }

  @override
  Future<void> unlike(String id){
    return _hive.unlike(id);
  }

  @override
  Stream<List<GifClass>> watchFavGifs() => _hive.watchFavGifs();

  @override
  Future<Set<String>> likedIds() async {
    return _hive.likedIds();
  }
}
