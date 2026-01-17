import 'package:weplay_music_streaming/features/auth/domain/entities/auth_entities.dart';

class AuthApiModel {
	final String? id;
	final String username;
	final String email;
	final String userType;
	final String? password;
	final String? profilePicture;

	AuthApiModel({
		this.id,
		required this.username,
		required this.email,
		required this.userType,
		this.password,
		this.profilePicture,
	});

  	Map<String, dynamic> toJson() {
		return {
			'username': username,
			'email': email,
			'userType': userType,
			'password': password,
			'profilePicture': profilePicture,
		};
	}

	factory AuthApiModel.fromJson(Map<String, dynamic> json) {
		return AuthApiModel(
			id: json['_id'] as String?,
			username: json['username'] as String,
			email: json['email'] as String,
			userType: json['userType'] as String,
			password: json['password'] as String?,
			profilePicture: json['profilePicture'] as String?,
		);
	}


	AuthEntity toEntity() {
		return AuthEntity(
			userId: id,
			username: username,
			email: email,
			userType: userType,
			password: password,
			profilePicture: profilePicture,
		);
	}

  	factory AuthApiModel.fromEntity(AuthEntity entity) {
		return AuthApiModel(
			id: entity.userId,
			username: entity.username,
			email: entity.email,
			userType: entity.userType,
			password: entity.password,
			profilePicture: entity.profilePicture,
		);
	}

	static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
		return models.map((model) => model.toEntity()).toList();
	}
}
