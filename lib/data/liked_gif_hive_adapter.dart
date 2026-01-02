import 'package:gif_imeges_app/data/liked_gif_hive.dart';
import 'package:hive/hive.dart';

class LikedGifEntityAdapter extends TypeAdapter<LikedGifEntity> {
  @override
  final int typeId = 1;

  @override
  LikedGifEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return LikedGifEntity(
      id: fields[0] as String,
      url: fields[1] as String,
      fixedUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LikedGifEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.fixedUrl);
  }
}
