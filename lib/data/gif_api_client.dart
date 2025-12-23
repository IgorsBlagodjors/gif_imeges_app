import 'package:dio/dio.dart';
import 'package:gif_imeges_app/data/api_key.dart';
import 'package:gif_imeges_app/data/gif_app_response.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';

class GifApiClient {
  final Dio _dio;
  GifApiClient(this._dio);

  Future<List<GifClass>> fetchGifs({
    String query = 'Shaman King',
    int limit = 30,
    int offset = 0,
  }) async {
    final queryParameters = {
      'api_key': ApiKey.gifApiKey,
      'q': query,
      'limit': limit,
      'offset': offset,
    };
    final response = await _dio.get(
      '/v1/gifs/search',
      queryParameters: queryParameters,
    );
    final fullResponse = FullResponse.fromJson(response.data);
    return fullResponse.toModel();
  }
}
