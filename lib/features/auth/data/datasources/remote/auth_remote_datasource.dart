import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

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
      final token = response.data['token'] as String?;
      
      final loggedInUser = AuthApiModel.fromJson(data);

      // Save token to secure storage
      if (token != null) {
        await _secureStorage.write(key: _tokenKey, value: token);
      }

      await _userSessionService.saveUserSession(
        userId: loggedInUser.id!, 
        email: loggedInUser.email, 
        userType: loggedInUser.userType, 
        username: loggedInUser.username,
        profilePicture: loggedInUser.profilePicture ?? '',
      );
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
  Future<bool> logout() async {
    try {
      // Clear token from secure storage
      await _secureStorage.delete(key: _tokenKey);
      
      // Clear user session from shared preferences
      await _userSessionService.clearSession();
      
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthApiModel> updateUser(AuthApiModel model, {String? filePath}) async {
    dynamic requestData;
    
    // If there's a file path, send as FormData for multer
    if (filePath != null && filePath.isNotEmpty) {
      requestData = FormData.fromMap({
        if (model.username.isNotEmpty) 'username': model.username,
        if (model.email.isNotEmpty) 'email': model.email,
        'profilePicture': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });
    } else {
      // Otherwise send as JSON
      requestData = model.toJson();
    }
    
    final response = await _apiClient.put(
      ApiEndpoints.updateUser,
      data: requestData,
    );
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final updatedUser = AuthApiModel.fromJson(data);
      
      // Update session with new user data
      await _userSessionService.saveUserSession(
        userId: updatedUser.id!,
        email: updatedUser.email,
        username: updatedUser.username,
        userType: updatedUser.userType,
        profilePicture: updatedUser.profilePicture ?? '',
      );
      
      return updatedUser;
    }
    return model;
  }



}