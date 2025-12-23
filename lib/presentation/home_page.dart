import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/domain/gif_app_repository.dart';
import 'package:gif_imeges_app/presentation/bloc/gif_list_cubit.dart';
import 'package:gif_imeges_app/presentation/bloc/gif_list_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  static Widget withCubit() => BlocProvider(
    create: (context) => GifListCubit(context.read<GifAppRepository>()),
    child: const HomePage(),
  );
}

class _HomePageState extends State<HomePage> {
  String? _queryFromLiveSearch;
  Timer? _searchTimer;
  late final GifListCubit _cubit;
  double _lastRequestedExtent = 0;
   final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<GifListCubit>(context);
    _cubit.fetchCollection(_queryFromLiveSearch);
  }

   @override
  void dispose() {
    _searchTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTopSafely() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF45278B),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextFormField(
              keyboardType: TextInputType.text,
              onChanged: (value) {
                _searchTimer?.cancel();
                _cubit.setOffset(offset: 0);
                _lastRequestedExtent = 0;
                _searchTimer = Timer(const Duration(milliseconds: 500), () {
                  _queryFromLiveSearch = value;
                 // _scrollToTopSafely();
                  _cubit.fetchCollection(value);
                  print('Searching for: $_queryFromLiveSearch');
                });
              },
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
            child: BlocBuilder<GifListCubit, GifListState>(
              builder: (context, state) {
                return switch (state) {
                  Error(:final message) => Center(
                    child: Text('Error: $message'),
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
                            metrics.pixels >= metrics.maxScrollExtent - thresholdPx &&
                            metrics.maxScrollExtent > _lastRequestedExtent;
                        if (shouldRequestMore) {
                          _lastRequestedExtent = metrics.maxScrollExtent;
                          _cubit.fetchCollection(_queryFromLiveSearch);
                          print('QUQRYYGSDFGDSFGDSFGSD ${_queryFromLiveSearch}');
                          print(  'AAAAAAAAAAAAAAAAAAAA ${_lastRequestedExtent}');
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
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: data.url,
                              fit: BoxFit.cover,
                              placeholder: (_, _) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (_, _, error) => const Center(
                                child: Icon(Icons.broken_image, size: 32),
                              ),
                            ),
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
