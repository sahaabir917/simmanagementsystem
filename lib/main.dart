import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:simcardmangment/controller/smsretrivecontroller.dart';
import 'package:simcardmangment/utils/keyboard_util.dart';
import 'package:simcardmangment/views/check_login_page.dart';
import 'package:simcardmangment/views/sms_sender_page.dart';
import 'package:simcardmangment/views/welcome_screen.dart';
import 'package:sms_plugin/sms.dart';
import 'package:sms_plugin/sms.dart' as smspackage;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  TextEditingController tokenTextController = TextEditingController();


  @override
  void initState() {
    checkPermission();
  }

  Future<void> init() async {
    try {
      var status = await Permission.phone.status;
      if (!status.isGranted) {
        bool isGranted = await Permission.phone.request().isGranted;
        if (!isGranted) return;
      }

      setState(() {
        _isLoading = false;
        // _simData = simData;
      });

      await printSimCardsData();
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> printSimCardsData() async {
    // SimCardsProvider provider = new SimCardsProvider();
    // SimCard card = await provider.getSimCards()[0];
    // SmsSender sender = new SmsSender();
    // SmsMessage message = new SmsMessage("01628781323", "message");
    // sender.sendSms(message, simCard: card);
    // sender.onSmsDelivered.listen((SmsMessage message){
    //   print('${message.address} received your message.');
    // });

    // SimCardsProvider provider = new SimCardsProvider();
    // var card = await provider.getSimCards();
    // print(card.length);
    // print("Length is " +card.length.toString());

    try {
      SimData simData = await SimDataPlugin.getSimData();
      int lengthofSimCard = simData.cards.length;
      // ignore: avoid_print
      print('Serial number: ${simData.cards[0].slotIndex}');

      SmsSender sender = new SmsSender();
      String address = "01628781323";
      SmsMessage message = new SmsMessage(address, 'Hello flutter!');
      SmsMessage message2 = new SmsMessage(address, 'from sim card 1');
      await sender.sendSms(message2,
          simCard: smspackage.SimCard(slot: 1, imei: "3123131123123"));
      message2.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          print("SMS is sent!");
        } else if (state == SmsMessageState.Delivered) {
          print("SMS is delivered!");
        }
      });
    } on PlatformException catch (e) {
      debugPrint("error! code: ${e.code} - message: ${e.message}");
    }
  }

  Future<void> printSimCardsDatas(String messageText, String phoneNumber,int messageNumber, int totalNumber) async {
    final SmsRetriveController smsRetriveController = Get.put(SmsRetriveController());
    // SimCardsProvider provider = new SimCardsProvider();
    // SimCard card = await provider.getSimCards()[0];
    // SmsSender sender = new SmsSender();
    // SmsMessage message = new SmsMessage("01628781323", "message");
    // sender.sendSms(message, simCard: card);
    // sender.onSmsDelivered.listen((SmsMessage message){
    //   print('${message.address} received your message.');
    // });

    // SimCardsProvider provider = new SimCardsProvider();
    // var card = await provider.getSimCards();
    // print(card.length);
    // print("Length is " +card.length.toString());
    // Obx((){
    //
    // });
    try {
      SimData simData = await SimDataPlugin.getSimData();
      int lengthofSimCard = simData.cards.length;
      // ignore: avoid_print
      print('Serial number: ${simData.cards[0].slotIndex}');

      SmsSender sender = new SmsSender();
      String address = phoneNumber;
      SmsMessage message = new SmsMessage(address, messageText);
      SmsMessage message2 = new SmsMessage(address, 'Hello fluttersadasd!');

        await sender.sendSms(message,
            simCard: smspackage.SimCard(slot: 2, imei: "3123131123123"));

      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          print("SMS is sent!");
        } else if (state == SmsMessageState.Delivered) {
          print("SMS is delivered!");
        }
      });

      if(messageNumber == totalNumber){
        await smsRetriveController.getMessages();
      }

    } on PlatformException catch (e) {
      debugPrint("error! code: ${e.code} - message: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: CheckLoginPage(),
      routes: {
        "/smsSenderPage":(context) => SmsSenderPage(),
        "/welcome_screen" :(context) => WelcomeScreen(),
        "/checkLoginPage" :(context) =>CheckLoginPage(),
      },
    );
  }

  void checkPermission() async{
   var status = await Permission.sms.status ;
   var status1 = await Permission.phone.status;
  if(status.isGranted && status1.isGranted){
    scheduleMicrotask(() => Navigator.of(context)
        .pushNamedAndRemoveUntil(
        '/checkLoginPage', (Route<dynamic> route) => false));
  }
  else {
    var status = await Permission.sms.request();
    var status1 = await Permission.phone.request();
  }
  }


}
