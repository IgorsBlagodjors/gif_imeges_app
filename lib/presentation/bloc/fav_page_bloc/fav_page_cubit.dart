import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/domain/favorites_repository.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';
import 'package:gif_imeges_app/presentation/bloc/fav_page_bloc/fav_page_state.dart';

class FavPageCubit extends Cubit<FavPageState> {
  final FavoritesRepository _favoritesRepository;
  StreamSubscription? _subscription;

  FavPageCubit(this._favoritesRepository) : super(const FavPageState.initial());

    void watch() {
    _subscription?.cancel();
    _subscription = _favoritesRepository.watchFavGifs().listen(
      (items) {
        emit(
          items.isEmpty
              ? const FavPageState.empty()
              : FavPageState.loaded(List.unmodifiable(items)),
        );
      },
      onError: (e) {
        emit(FavPageState.error(e.toString()));
      },
    );
  }

  Future<void> toggleLike(GifClass gif) async {
    try {
      if (gif.isLiked) {
        await _favoritesRepository.unlike(gif.id);
      } else {
        await _favoritesRepository.like(gif);
      }
    } catch (e) {
      emit(FavPageState.error(e.toString()));
    }
  }

    @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
