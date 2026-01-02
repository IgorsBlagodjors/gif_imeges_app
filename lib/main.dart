import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/data/gif_api_client.dart';
import 'package:gif_imeges_app/data/hive_database_client.dart';
import 'package:gif_imeges_app/data/liked_gif_hive.dart';
import 'package:gif_imeges_app/data/liked_gif_hive_adapter.dart';
import 'package:gif_imeges_app/data/memory_gif_repository.dart';
import 'package:gif_imeges_app/data/network_gif_repository.dart';
import 'package:gif_imeges_app/domain/favorites_repository.dart';
import 'package:gif_imeges_app/domain/gif_app_repository.dart';
import 'package:gif_imeges_app/presentation/routes/app_routes.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
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

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(LikedGifEntityAdapter());
  final likedBox = await Hive.openBox<LikedGifEntity>('liked_gifs');

  final GifApiClient gifApiClient = GifApiClient(dio);
  final networkGifRepository = NetworkGifRepository(gifApiClient);
  final networkGifRepositoryProvider = RepositoryProvider<GifAppRepository>(
    create: (context) => networkGifRepository,
  );
  final HiveDatabaseClient hiveDatabaseClient = HiveDatabaseClient(likedBox);
  final memoryGifRepository = MemoryGifRepository(hiveDatabaseClient);
  final favoritesRepositoryProvider = RepositoryProvider<FavoritesRepository>(
    create: (context) => memoryGifRepository,
  );
  runApp(
    MultiRepositoryProvider(
      providers: [networkGifRepositoryProvider, favoritesRepositoryProvider],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
}
