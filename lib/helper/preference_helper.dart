import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper{

  static SharedPreferences pref;

  void setToken(String token) async{
    pref = await SharedPreferences.getInstance();
    pref.setString("token", token);
    pref.commit();
    print("token saved");
  }

  void setIsLoggedIn(bool isLogin) async{
    pref = await SharedPreferences.getInstance();
    pref.setBool("isLogin", isLogin);
    pref.commit();
  }


}