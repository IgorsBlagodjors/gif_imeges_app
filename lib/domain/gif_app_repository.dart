import 'package:gif_imeges_app/domain/gif_class.dart';

abstract class GifAppRepository {
  Future<List<GifClass>> fetchGifs(String query, int offset);
}