import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gif_imeges_app/domain/gif_class.dart';

part 'fav_page_state.freezed.dart';

@freezed
class FavPageState with _$FavPageState {
  const factory FavPageState.initial() = Initial;
  const factory FavPageState.empty() = EmptyState;
  const factory FavPageState.loaded(List<GifClass> favGifs) = Loaded;
  const factory FavPageState.error(String message) = Error;
}
