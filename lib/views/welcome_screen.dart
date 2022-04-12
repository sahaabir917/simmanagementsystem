import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simcardmangment/controller/smsretrivecontroller.dart';
import 'package:simcardmangment/helper/preference_helper.dart';
import 'package:simcardmangment/utils/keyboard_util.dart';
import 'package:simcardmangment/views/sms_sender_page.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final SmsRetriveController smsRetriveController =
      Get.put(SmsRetriveController());
  TextEditingController tokenTextController = TextEditingController();
  PreferenceHelper preferenceHelper = PreferenceHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("send sms"),
        ),
        body: ScreenUtilInit(
          designSize: Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: () => Container(
            color: Colors.grey,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 0.2.sh,
                ),
                Container(
                    padding: EdgeInsets.only(left: 0.2.sw, right: 0.2.sw),
                    height: .09.sh,
                    width: 1.sw,
                    child: TextFormField(
                      controller: tokenTextController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Token",
                        hintStyle: TextStyle(color: Colors.black12),
                      ),
                    )),
                Container(
                    padding: EdgeInsets.only(left: 0.2.sw, right: 0.2.sw),
                    height: .04.sh,
                    width: 1.sw,
                    child: RaisedButton(
                      color: Colors.green,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (tokenTextController.text == "") {
                          //show a dialog;
                          print("show a dialog");
                        } else {
                          KeyboardUtil.hideKeyboard(context);
                          var token = tokenTextController.text;
                          print("token is ${token}");
                          await smsRetriveController.saveToken(token);
                          await preferenceHelper.setIsLoggedIn(true);
                          print("token is ${token}");
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => SmsSenderPage()),
                              (Route<dynamic> route) => false);
                          // printSimCardsDatas();
                          //now need to check if the status code is 200 or not ., if 500 then give a toast or popup window.
                        }
                      },
                    )),
              ],
            ),
            // child: RaisedButton(
            //   child: Text("Send SMS"),
            //   onPressed: () {
            //     printSimCardsData();
            //     printSimCardsDatas();
            //   },
            // ),
          ),
        ));
  }
}
