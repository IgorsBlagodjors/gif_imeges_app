import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/domain/gif_app_repository.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';
import 'package:gif_imeges_app/presentation/bloc/gif_list_state.dart';

class GifListCubit extends Cubit<GifListState> {
  final GifAppRepository _repo;
  int _offset = 0;
  final List<GifClass> _gifs = [];

  GifListCubit(this._repo) : super(const GifListState.initial());

  Future<void> fetchCollection(String? query) async {
    final isFirstPage = _offset == 0;
    try {
      final items = await _repo.fetchGifs(query, _offset);
      if (isFirstPage) _gifs.clear();
      _gifs.addAll(items);
      _offset += 30;
      print('AAAAAAAAAAAA ${_gifs.length}');
      emit(
        _gifs.isEmpty
            ? const GifListState.empty()
            : GifListState.loaded(List.unmodifiable(_gifs)),
      );
    } catch (e, st) {
      emit(GifListState.error(e.toString()));
    }
  }

  void setOffset({required int offset}) => _offset = offset;
}
