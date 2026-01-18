import 'package:weplay_music_streaming/core/services/hive/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/services/storage/user_session_service.dart';
import 'package:weplay_music_streaming/features/auth/data/datasources/auth_datasource.dart';
import 'package:weplay_music_streaming/features/auth/data/models/auth_hive_model.dart';

// Provider
final authLocalDatasourceProvider =Provider<AuthLocalDatasource>((ref){
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService, userSessionService: userSessionService);
});

  
class AuthLocalDatasource implements IAuthLocalDatasource{

final HiveService _hiveService;

final UserSessionService _userSessionService;
  
  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService
    }): _hiveService = hiveService, 
        _userSessionService= userSessionService;
   
     @override
     Future<AuthHiveModel> getCurrentUser() async {
      try{
       final user = await _hiveService.getCurrentUser();
       return Future.value(user);
      } catch (e) {
        throw Future.value(null);
      }
      
     }
   
     @override
     Future<AuthHiveModel?> login(String email, String password) async {
      try{
       final user =await _hiveService.loginUser(email, password);
       
       if (user != null){
        await _userSessionService.saveUserSession(
          userId: user.userId!,
          email: user.email,
          username: user.username,
          userType: user.userType,
          profilePicture: user.profilePicture?? "",
        );
       }
       return user;
      } catch (e) {
        throw Future.value(null);
      }
     }
   
     @override
     Future<bool> logout() async{
      try {
      await _hiveService.logoutUser();
      await _userSessionService.clearSession();
      return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
     }
   
     @override
     Future<bool> register(AuthHiveModel model) async{
      try {
      await  _hiveService.registerUser(model);
      return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
     }


 
}