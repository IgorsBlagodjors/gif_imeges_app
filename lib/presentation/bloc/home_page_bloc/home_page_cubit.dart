import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/domain/favorites_repository.dart';
import 'package:gif_imeges_app/domain/gif_app_repository.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';
import 'package:gif_imeges_app/presentation/bloc/home_page_bloc/home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final GifAppRepository _repo;
  final FavoritesRepository _favoritesRepository;
  GifQuery _query = const GifQuery(term: '');
  Set<String> _likedIds = {};

  HomePageCubit(this._repo, this._favoritesRepository)
    : super(const HomePageState.initial());

  Future<void> search(String term) async {
    _query = _query.newSearch(term);
    try {
      await _refreshLikedIds();
      final items = await _repo.fetchGifs(term, _query.offset);
      final withLikes = _applyLikes(items);

      if (withLikes.isEmpty) {
        emit(const HomePageState.empty());
      } else {
        emit(HomePageState.loaded(List.unmodifiable(withLikes)));
        _query = _query.nextPage();
      }
    } catch (e) {
      emit(HomePageState.error(e.toString()));
    }
  }

  Future<void> loadMore() async {
    try {
      await _refreshLikedIds();
      final newItems = await _repo.fetchGifs(_query.term, _query.offset);

      if (newItems.isEmpty) return;

      final withLikes = _applyLikes(newItems);

      emit(HomePageState.loaded(List.unmodifiable(state.gifs + withLikes)));
      _query = _query.nextPage();
    } catch (e) {
      emit(HomePageState.error(e.toString()));
    }
  }

  Future<void> toggleLike(GifClass gif) async {
    try {
      final willLike = !_likedIds.contains(gif.id);

      if (willLike) {
        await _favoritesRepository.like(gif);
        _likedIds.add(gif.id);
      } else {
        await _favoritesRepository.unlike(gif.id);
        _likedIds.remove(gif.id);
      }

      final updated = state.gifs
          .map(
            (g) => g.id == gif.id
                ? GifClass(
                    id: g.id,
                    url: g.url,
                    fixedUrl: g.fixedUrl,
                    isLiked: willLike,
                  )
                : g,
          )
          .toList(growable: false);

      emit(HomePageState.loaded(List.unmodifiable(updated)));
    } catch (e) {
      emit(HomePageState.error(e.toString()));
    }
  }

  Future<void> _refreshLikedIds() async {
    _likedIds = await _favoritesRepository.likedIds();
  }

  List<GifClass> _applyLikes(List<GifClass> items) {
    for (final g in items) {
      g.isLiked = _likedIds.contains(g.id);
    }
    return items;
  }

  Future<void> refreshLikesOnly() async {
    await _refreshLikedIds();

    final updated = state.gifs
        .map(
          (g) => GifClass(
            id: g.id,
            url: g.url,
            fixedUrl: g.fixedUrl,
            isLiked: _likedIds.contains(g.id),
          ),
        )
        .toList(growable: false);

    emit(HomePageState.loaded(List.unmodifiable(updated)));
  }
}
