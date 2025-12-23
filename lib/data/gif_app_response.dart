import 'package:gif_imeges_app/domain/gif_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gif_app_response.g.dart';

@JsonSerializable(createToJson: false)
class FullResponse {
  List<GifData> data;
  FullResponse({required this.data});

  List<GifClass> toModel() {
    return data
        .map(
          (dataItem) => GifClass(
            id: dataItem.id,
            url: dataItem.images.original.url,
            width: dataItem.images.original.width,
            height: dataItem.images.original.height,
          ),
        )
        .toList();
  }

  factory FullResponse.fromJson(Map<String, dynamic> json) =>
      _$FullResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class GifData {
  String id;
  Images images;
  GifData({required this.id, required this.images});

  factory GifData.fromJson(Map<String, dynamic> json) =>
      _$GifDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class Images {
  OriginalImages original;
  Images({required this.original});

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
}

@JsonSerializable(createToJson: false)
class OriginalImages {
  String url;
  String width;
  String height;
  OriginalImages({
    required this.url,
    required this.width,
    required this.height,
  });

  factory OriginalImages.fromJson(Map<String, dynamic> json) =>
      _$OriginalImagesFromJson(json);
}
