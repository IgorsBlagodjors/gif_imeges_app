import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';

part 'gif_list_state.freezed.dart';

@freezed
class GifListState with _$GifListState {
  const factory GifListState.initial() = Initial;
  const factory GifListState.loading() = Loading;
  const factory GifListState.empty() = EmptyState;
  const factory GifListState.loaded(List<GifClass> gifs) = Loaded;
  const factory GifListState.error(String message) = Error;
}
