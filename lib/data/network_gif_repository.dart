import 'package:gif_imeges_app/data/gif_api_client.dart';
import 'package:gif_imeges_app/domain/gif_app_repository.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';

class NetworkGifRepository implements GifAppRepository {
  final GifApiClient _gifApiClient;

  NetworkGifRepository(this._gifApiClient);

  @override
  Future<List<GifClass>> fetchGifs(String query, int offset) async {
    final response = await _gifApiClient.fetchGifs(query: query, offset: offset);
    return response;
  }
}
