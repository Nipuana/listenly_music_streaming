import 'package:hive/hive.dart';
import 'package:weplay_music_streaming/core/constants/hive_table_constant.dart';
import 'package:weplay_music_streaming/features/auth/domain/entities/auth_entities.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject{


    @HiveField(0)
    final String? userId;
    @HiveField(1)
    final String username;
    @HiveField(2)
    final String email;
    @HiveField(3)
    final String userType;
    @HiveField(4)
    final String? password;
    @HiveField(5)
    final String? profilePicture;

    AuthHiveModel({
      this.userId,
      required this.username,
      required this.email,
      required this.userType,
      this.password,
      this.profilePicture 
    });

//From entity
    factory AuthHiveModel.fromEntity(AuthEntity entity) {
      return AuthHiveModel(
        userId: entity.userId,
        username: entity.username,
        email: entity.email,
        userType: entity.userType,
        password: entity.password,
        profilePicture: entity.profilePicture,
      );
    }
//To entity
    AuthEntity toEntity() {
      return AuthEntity(
        userId: userId,
        username: username,
        email: email,
        userType: userType,
        password: password,
        profilePicture: profilePicture,
      );
    }

//To entity list
    static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
      return models.map((model) => model.toEntity()).toList();
    }
}