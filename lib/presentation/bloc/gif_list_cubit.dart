import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_imeges_app/domain/gif_app_repository.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';
import 'package:gif_imeges_app/presentation/bloc/gif_list_state.dart';
import 'package:logger/logger.dart';

class GifListCubit extends Cubit<GifListState> {
  final GifAppRepository _gifAppRepository;
  int _offset = 0;
  final logger = Logger();


  GifListCubit(this._gifAppRepository)
    : super(const GifListState.initial());

  Future<void> fetchCollection(String? query) async {
    final isFirstPage = _offset == 0;
    final previous = switch (state) {
      Loaded(:final gifs) => gifs,
      _ => const <GifClass>[],
    };
    try {
      final items = await _gifAppRepository.fetchGifs(query, _offset);
      final combined = isFirstPage ? items : previous + items;
      _offset += 30;
      emit(GifListState.loaded(combined));
      print('LENGHT ${combined.length}');
    } on Exception catch (ex, stacktrace) {
      logger.e('Failed to load: ex $ex, stacktrace: $stacktrace');
      emit(GifListState.error(ex.toString()));
    }
  }

  setOffset({required int offset}) {
    _offset = offset;
  }
}
