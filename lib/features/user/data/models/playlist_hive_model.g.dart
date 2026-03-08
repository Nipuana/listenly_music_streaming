// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistHiveModelAdapter extends TypeAdapter<PlaylistHiveModel> {
  @override
  final int typeId = 2;

  @override
  PlaylistHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistHiveModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String?,
      coverImageUrl: fields[3] as String?,
      visibility: fields[4] as String,
      createdBy: fields[5] as String?,
      createdByUsername: fields[6] as String?,
      songsJson: fields[7] as String,
      favoriteCount: fields[8] as int,
      songCount: fields[9] as int,
      totalDuration: fields[10] as int,
      isFavorited: fields[11] as bool?,
      cachedAt: fields[12] as String,
      collectionKey: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistHiveModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.coverImageUrl)
      ..writeByte(4)
      ..write(obj.visibility)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.createdByUsername)
      ..writeByte(7)
      ..write(obj.songsJson)
      ..writeByte(8)
      ..write(obj.favoriteCount)
      ..writeByte(9)
      ..write(obj.songCount)
      ..writeByte(10)
      ..write(obj.totalDuration)
      ..writeByte(11)
      ..write(obj.isFavorited)
      ..writeByte(12)
      ..write(obj.cachedAt)
      ..writeByte(13)
      ..write(obj.collectionKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
