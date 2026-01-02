import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/design_system/app_colors.dart';
import 'package:gif_imeges_app/domain/favorites_repository.dart';
import 'package:gif_imeges_app/domain/gif_app_repository.dart';
import 'package:gif_imeges_app/presentation/bloc/home_page_bloc/home_page_cubit.dart';
import 'package:gif_imeges_app/presentation/bloc/home_page_bloc/home_page_state.dart';
import 'package:gif_imeges_app/presentation/routes/app_route_names.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  static Widget withCubit() => BlocProvider(
    create: (context) => HomePageCubit(
      context.read<GifAppRepository>(),
      context.read<FavoritesRepository>(),
    ),
    child: const HomePage(),
  );
}

class _HomePageState extends State<HomePage> {
  Timer? _searchTimer;
  late final HomePageCubit _cubit;
  double _lastRequestedExtent = 0;
  static const _debounceDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<HomePageCubit>(context);
    _cubit.search('cat');
  }

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();
    _lastRequestedExtent = 0;
    _searchTimer = Timer(_debounceDuration, () {
      _cubit.search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          SizedBox(height: 50),
          GestureDetector(
            onTap: () async {
              await context.pushNamed(AppRouteNames.favorites);
              _cubit.refreshLikesOnly();
            },
            child: Icon(Icons.gif, size: 100, color: Colors.white),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextFormField(
              keyboardType: TextInputType.text,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: 'Live search...',
                hintStyle: const TextStyle(color: Colors.black),
                contentPadding: const EdgeInsets.only(
                  left: 48,
                  top: 20,
                  right: 147,
                  bottom: 20,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 24, right: 16),
                  child: Icon(Icons.search, color: Colors.black),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HomePageCubit, HomePageState>(
              builder: (context, state) {
                return switch (state) {
                  Error(:final message) => Center(
                    child: Text('Error: $message'),
                  ),
                  EmptyState() => const Center(
                    child: Text(
                      'Problem with internet connection or no results found.',
                    ),
                  ),
                  Loaded(:final gifs) =>
                    NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        final metrics = notification.metrics;
                        if (metrics.maxScrollExtent <= 0) {
                          return false;
                        }
                        const thresholdPx = 300.0;
                        final shouldRequestMore =
                            metrics.pixels >=
                                metrics.maxScrollExtent - thresholdPx &&
                            metrics.maxScrollExtent > _lastRequestedExtent;
                        if (shouldRequestMore) {
                          _lastRequestedExtent = metrics.maxScrollExtent;
                          _cubit.loadMore();
                        }
                        return false;
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemBuilder: (_, index) {
                          final data = gifs[index];
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: data.fixedUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, _) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (_, _, error) => const Center(
                                    child: Icon(Icons.broken_image, size: 32),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 2,
                                top: 2,
                                child: IconButton(
                                  onPressed: () => _cubit.toggleLike(data),
                                  icon: Icon(
                                    data.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: data.isLiked
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: gifs.length,
                      ),
                    ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
