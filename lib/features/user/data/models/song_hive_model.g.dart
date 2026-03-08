// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongHiveModelAdapter extends TypeAdapter<SongHiveModel> {
  @override
  final int typeId = 1;

  @override
  SongHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongHiveModel(
      id: fields[0] as String?,
      title: fields[1] as String,
      album: fields[2] as String?,
      genre: fields[3] as String,
      duration: fields[4] as int?,
      audioUrl: fields[5] as String?,
      coverImageUrl: fields[6] as String?,
      playCount: fields[7] as int,
      likeCount: fields[8] as int,
      visibility: fields[9] as String,
      uploadedBy: fields[10] as String?,
      uploadedByUsername: fields[11] as String?,
      uploadedByProfilePicture: fields[12] as String?,
      isLiked: fields[13] as bool?,
      cachedAt: fields[14] as String,
      collectionKey: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SongHiveModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.album)
      ..writeByte(3)
      ..write(obj.genre)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.audioUrl)
      ..writeByte(6)
      ..write(obj.coverImageUrl)
      ..writeByte(7)
      ..write(obj.playCount)
      ..writeByte(8)
      ..write(obj.likeCount)
      ..writeByte(9)
      ..write(obj.visibility)
      ..writeByte(10)
      ..write(obj.uploadedBy)
      ..writeByte(11)
      ..write(obj.uploadedByUsername)
      ..writeByte(12)
      ..write(obj.uploadedByProfilePicture)
      ..writeByte(13)
      ..write(obj.isLiked)
      ..writeByte(14)
      ..write(obj.cachedAt)
      ..writeByte(15)
      ..write(obj.collectionKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
