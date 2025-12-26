import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/domain/favorites_repository.dart';
import 'package:gif_imeges_app/presentation/bloc/fav_page/fav_page_state.dart';

class FavPageCubit extends Cubit<FavPageState> {
  final FavoritesRepository _favoritesRepository;
  FavPageCubit(this._favoritesRepository) : super(const FavPageState.initial());

  Future<void> fetchFavGifs() async {
    try {
      final items = await _favoritesRepository.fetchFavGifs();
      print('FAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ${items.length}');
      emit(
        
        items.isEmpty
            ? const FavPageState.empty()
            : FavPageState.loaded(List.unmodifiable(items)),
      );
    } catch (e, st) {
      emit(FavPageState.error(e.toString()));
    }
  }
}
