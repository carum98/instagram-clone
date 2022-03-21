import 'package:instagram_clone/core/auth.dart';
import 'package:instagram_clone/model/user_model.dart';

class UserProvider {
  UserModel? _user;

  UserModel get user => _user!;

  Future<void> getUser() async {
    _user = await Auth().getUser();
  }
}
