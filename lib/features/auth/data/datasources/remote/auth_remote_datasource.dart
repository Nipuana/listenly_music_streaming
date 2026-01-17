import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_client.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/features/auth/data/datasources/auth_datasource.dart';
import 'package:weplay_music_streaming/features/auth/data/models/auth_hive_model.dart';

// make a provider
final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {

  return AuthRemoteDatasource(
       apiClient : ref.watch(apiClientProvider),
       userSessionService : ref.watch(userSessionServiceProvider),
  );
});


class AuthRemoteDatasource implements IAuthRemoteDatasource{

  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

//Constructor
  AuthRemoteDatasource({
    required ApiClient apiClient, 
    required UserSessionService userSessionService
    }): _apiClient = apiClient,
        _userSessionService = userSessionService;


  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<bool> register(AuthHiveModel model) {
    // TODO: implement register
    throw UnimplementedError();
  }
}