import 'package:gif_imeges_app/data/liked_gif_hive.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';
import 'package:hive/hive.dart';

class HiveDatabaseClient {
  final Box<LikedGifEntity> _box;

  HiveDatabaseClient(this._box);

  GifClass _toModel(LikedGifEntity e) =>
      GifClass(id: e.id, url: e.url, fixedUrl: e.fixedUrl, isLiked: true);

  LikedGifEntity _toEntity(GifClass g) =>
      LikedGifEntity(id: g.id, url: g.url, fixedUrl: g.fixedUrl);

  Future<void> like(GifClass gif) async{
    await _box.put(gif.id, _toEntity(gif));
  }

  Future<void> unlike(String id) async {
    await _box.delete(id);
  }

  Future<Set<String>> likedIds() async {
    return _box.keys.cast<String>().toSet();
  }

  Stream<List<GifClass>> watchFavGifs() async* {
    yield _box.values.map(_toModel).toList(growable: false);

    await for (final _ in _box.watch()) {
      yield _box.values.map(_toModel).toList(growable: false);
    }
  }
}
