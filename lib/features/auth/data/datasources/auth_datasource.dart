import 'package:weplay_music_streaming/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthLocalDatasource{
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();

}


abstract interface class IAuthRemoteDatasource{
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();

}