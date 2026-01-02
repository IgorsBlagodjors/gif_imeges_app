import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState.initial() = Initial;
  const factory HomePageState.loading() = Loading;
  const factory HomePageState.empty() = EmptyState;
  const factory HomePageState.loaded(List<GifClass> gifs) = Loaded;
  const factory HomePageState.error(String message) = Error;
}

@freezed
sealed class GifQuery with _$GifQuery {
  const factory GifQuery({
    required String term,
    @Default(0) int offset,
    @Default(30) int limit,
  }) = _GifQuery;
}

extension GifListStateX on HomePageState {
  List<GifClass> get gifs =>
      maybeMap(loaded: (s) => s.gifs, orElse: () => const []);
}

extension GifQueryX on GifQuery {
  GifQuery nextPage() => copyWith(offset: offset + limit);

  GifQuery newSearch(String newTerm) => copyWith(
    term: newTerm,
    offset: 0,
  );

  GifQuery reset() => copyWith(offset: 0);
}
