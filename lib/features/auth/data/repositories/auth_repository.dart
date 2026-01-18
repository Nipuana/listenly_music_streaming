import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weplay_music_streaming/core/error/faliures.dart';
import 'package:weplay_music_streaming/core/services/connectivity/network_info.dart';
import 'package:weplay_music_streaming/features/auth/data/datasources/auth_datasource.dart';
import 'package:weplay_music_streaming/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:weplay_music_streaming/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:weplay_music_streaming/features/auth/data/models/auth_api_model.dart';
// import 'package:weplay_music_streaming/features/auth/data/models/auth_hive_model.dart';
import 'package:weplay_music_streaming/features/auth/domain/entities/auth_entities.dart';
import 'package:weplay_music_streaming/features/auth/domain/repositories/auth_repository.dart';

//Provider
final authRepositoryProvider =  Provider<IAuthRepository>((ref){
  final authLocalDatasource= ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource= ref.read(authRemoteDataSourceProvider);
  final networkInfo= ref.read(networkInfoProvider);
  return AuthRepository(
    authLocalDatasource: authLocalDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  
  final IAuthLocalDatasource _authLocalDatasource;
  final IAuthRemoteDatasource _authRemoteDatasource;
  final INetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDatasource authLocalDatasource,
    required IAuthRemoteDatasource authRemoteDatasource,
    required INetworkInfo networkInfo,
  })  : _authLocalDatasource = authLocalDatasource,
        _authRemoteDatasource = authRemoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
   try{
      final user =  await _authLocalDatasource.getCurrentUser();
      if(user !=null){
        final entity = user.toEntity();
        return Right( entity);
      } else {
        return Left( LocalDatabaseFailure (message: "No current user found"));
      }
    } catch (e) {
      return Left(LocalDatabaseFailure (message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    if (await _networkInfo.isConnected) {
      try{
        final apiModel = await _authRemoteDatasource.login(email, password);
        if (apiModel != null){
          final entity = apiModel.toEntity();
          return Right( entity);
        } 
        return Left(ApiFailure (message: "Login failed"));
      } on DioException catch(e){
        return Left(
          ApiFailure (message:e.response?.data['message'] ?? "Login failed", 
          statusCode: e.response?.statusCode
          ));
      } catch (e) {
        return Left(ApiFailure (message: e.toString()));
      }
    } else {
      // Login from local database
      try{
        final hiveModel = await _authLocalDatasource.login(email, password);
        if (hiveModel != null){
          final entity = hiveModel.toEntity();
          return Right( entity);
        } else {
          return Left(LocalDatabaseFailure (message: "Login failed"));
        }
      } catch (e) {
        return Left(LocalDatabaseFailure (message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async{
    try{
      final result = await _authLocalDatasource.logout();
      if(result){
        return Right( true);
      }
      return Left(LocalDatabaseFailure (message: "Logout failed"));
    } catch (e) {
      return Left(LocalDatabaseFailure (message: e.toString()));
    }

  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async{
    if (await _networkInfo.isConnected) {
     try{
       final apiModel=AuthApiModel.fromEntity(entity);
      await _authRemoteDatasource.register(apiModel);
      return Right(true);
     }on DioException catch(e){
      return Left(ApiFailure (message:e.response?.data['message'] ?? "Registration failed", statusCode: e.response?.statusCode));
     } catch (e) {
      return Left(ApiFailure (message: e.toString()));
     }
    }else{
      return Left(ApiFailure (message: "No internet connection"));
      }
    //================code for local registration only================ 
    // else{
    //   try{
    //   final model = AuthHiveModel.fromEntity(entity);
    //   final result = await _authLocalDatasource.register(model);
    //   if (result){
    //     return Right(true);
    //   } else {
    //     return Left(LocalDatabaseFailure (message: "Registration failed"));
    //   }
    //   } catch (e) {
    //   return Left(LocalDatabaseFailure (message: e.toString()));
    //   }
    //   }
    }
  }
