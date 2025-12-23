import 'package:gif_imeges_app/domain/gif_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gif_app_response.g.dart';

@JsonSerializable(createToJson: false)
class FullResponse {
  final List<GifData> data;
  FullResponse({required this.data});

  List<GifClass> toModel() {
    return data
        .map(
          (dataItem) => GifClass(
            id: dataItem.id,
            url: dataItem.images.original.url,
            fixedUrl: dataItem.images.fixedWidthSmall.url,
          ),
        )
        .toList();
  }

  factory FullResponse.fromJson(Map<String, dynamic> json) =>
      _$FullResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class GifData {
  final String id;
  final Images images;
  GifData({required this.id, required this.images});

  factory GifData.fromJson(Map<String, dynamic> json) =>
      _$GifDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class Images {
  final OriginalImages original;

  @JsonKey(name: 'fixed_width_small')
  final OriginalImages fixedWidthSmall;

  Images({required this.original, required this.fixedWidthSmall});

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
}

@JsonSerializable(createToJson: false)
class OriginalImages {
  final String url;

  OriginalImages({
    required this.url,
  });

  factory OriginalImages.fromJson(Map<String, dynamic> json) =>
      _$OriginalImagesFromJson(json);
}
