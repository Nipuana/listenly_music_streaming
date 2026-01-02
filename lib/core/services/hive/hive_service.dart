import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weplay_music_streaming/core/constants/hive_table_constant.dart';
import 'package:weplay_music_streaming/features/auth/data/models/auth_hive_model.dart';

class HiveService {

  // init 
  Future<void> init() async {
   final directory = await getApplicationDocumentsDirectory();
   final path='${directory.path}/${HiveTableConstant.dbName}';
   
   Hive.init(path);
   _registerAdapters();
  }

  // Register Adapters
  void _registerAdapters() {
    if(!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)){
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }
  // Open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }
  // Close Boxes
  Future<void> closeBoxes() async {
    await Hive.close();
  }


  // ################################ AUTH QUERIES ################################

  Box<AuthHiveModel> get _authBox =>
    Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // -------- Register User --------
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.userId, model);
    return model;
  }

  // -------- Login User --------
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password);

    if (users.isNotEmpty) {
      return users.first;
    } 
    return null;
  }

  // -------- Get Current User --------
  AuthHiveModel? getCurrentUser(String userId) {
    return _authBox.get(userId);
  }

  // -------- Logout User --------
  Future<void> logoutUser(String userId) async {
    await _authBox.delete(userId);
  }


}