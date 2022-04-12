import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcardmangment/views/sms_sender_page.dart';
import 'package:simcardmangment/views/welcome_screen.dart';

class CheckLoginPage extends StatefulWidget {


  @override
  _CheckLoginPageState createState() => _CheckLoginPageState();
}

class _CheckLoginPageState extends State<CheckLoginPage> {
  bool isLogin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  @override
  void initState() {
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("isLogin") != null) {
      if (preferences.getBool("isLogin") == true) {
        isLogin = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
            (SmsSenderPage()),
          ),
        );
      }
      else{
        isLogin == false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
            (WelcomeScreen()),
          ),
        );

      }
    }
    else{
      isLogin = false;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
          (WelcomeScreen()),
        ),
      );
    }
  }
}
