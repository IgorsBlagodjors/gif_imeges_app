import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/data/gif_api_client.dart';
import 'package:gif_imeges_app/data/network_gif_repository.dart';
import 'package:gif_imeges_app/domain/gif_app_repository.dart';
import 'package:gif_imeges_app/presentation/home_page.dart';

void main() {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.giphy.com'));
  dio.interceptors.add(
    LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
      request: true,
    ),
  );

  final GifApiClient gifApiClient = GifApiClient(dio);
  final networkGifRepository = NetworkGifRepository(gifApiClient);
  final networkGifRepositoryProvider = RepositoryProvider<GifAppRepository>(
    create: (context) => networkGifRepository,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [networkGifRepositoryProvider],
      child: MaterialApp(home: HomePage.withCubit()),
    ),
  );
}
