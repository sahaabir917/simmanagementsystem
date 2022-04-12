
import 'package:shared_preferences/shared_preferences.dart';

class CommonUtils{


  Future<String> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwttoken = sharedPreferences.getString("token");
    return jwttoken;
  }

}