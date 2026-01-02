import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/design_system/app_colors.dart';
import 'package:gif_imeges_app/domain/favorites_repository.dart';
import 'package:gif_imeges_app/presentation/bloc/fav_page_bloc/fav_page_cubit.dart';
import 'package:gif_imeges_app/presentation/bloc/fav_page_bloc/fav_page_state.dart';
import 'package:go_router/go_router.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
  static Widget withCubit() => BlocProvider(
    create: (context) => FavPageCubit(context.read<FavoritesRepository>()),
    child: const FavPage(),
  );
}

class _FavPageState extends State<FavPage> {
  late final FavPageCubit _cubit;

  @override
  initState() {
    super.initState();
    _cubit = BlocProvider.of<FavPageCubit>(context);
    _cubit.watch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(Icons.arrow_back, size: 32, color: Colors.white),
          ),
          Expanded(
            child: BlocBuilder<FavPageCubit, FavPageState>(
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
                  Loaded(:final favGifs) => GridView.builder(
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
                      final data = favGifs[index];
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
                                color: data.isLiked ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: favGifs.length,
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
