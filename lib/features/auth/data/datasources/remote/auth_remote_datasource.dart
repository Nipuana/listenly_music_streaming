import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/api/api_client.dart';
import 'package:weplay_music_streaming/core/api/api_endpoints.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/features/auth/data/datasources/auth_datasource.dart';
import 'package:weplay_music_streaming/features/auth/data/models/auth_api_model.dart';

// make a provider
final authRemoteDataSourceProvider = Provider<IAuthRemoteDatasource>((ref) {

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
  Future<AuthApiModel?> login(String email, String password) async {
    final response =await _apiClient.post(
      ApiEndpoints.loginUser,
      data: {
        'email': email,
        'password': password,
      },
    );
  
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final loggedInUser = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(userId: loggedInUser.id!, email: loggedInUser.email, userType: loggedInUser.userType, username: loggedInUser.username);
      return loggedInUser;
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel model) async{
    final response = await _apiClient.post(
      ApiEndpoints.registerUser,
      data: model.toJson(),
    );
    if (response.data['success']==true){
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    } 
    return model;
  }

  @override
  Future<AuthApiModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }


  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }



}