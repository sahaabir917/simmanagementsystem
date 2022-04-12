import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:sim_data/sim_model.dart';
import 'package:simcardmangment/controller/smsretrivecontroller.dart';
import 'package:sms_plugin/sms.dart';
import 'package:sms_plugin/sms.dart' as smspackage;

class SmsSenderPage extends StatefulWidget {


  @override
  _SmsSenderPageState createState() => _SmsSenderPageState();
}

class _SmsSenderPageState extends State<SmsSenderPage> {
  final SmsRetriveController smsRetriveController = Get.put(SmsRetriveController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Message Sending service on"),
    );
  }

  @override
  void initState() {
   var timer = Timer.periodic(Duration(seconds: 15), (Timer t) => smsRetriveController.getAgainMessages());
    // smsRetriveController.getMessages();
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

    var status = await Permission.sms.status;
    var status1 = await Permission.phone.status;
    print("status is ${status} and status1 is ${status1}");
    if(status.isGranted && status1.isGranted){
      try {

        SmsSender sender = new SmsSender();
        String address = phoneNumber;
        SmsMessage message = new SmsMessage(address, messageText);
        SmsMessage message2 = new SmsMessage(address, 'Hello fluttersadasd!');

        await sender.sendSms(message,
            simCard: smspackage.SimCard(slot: 2, imei: "3123131123123"));

        message.onStateChanged.listen((state) async {
          if (state == SmsMessageState.Sent) {
            print("SMS is sent!");
          } else if (state == SmsMessageState.Delivered) {
            print("SMS is delivered!");
            if(messageNumber == totalNumber-1){
              print("call again getmessage api");
               // smsRetriveController.getMessages();
               smsRetriveController.getAgainMessages();
            }
          }
        });

        print("message number is : ${messageNumber} and total number is ${totalNumber-1}");



      } on PlatformException catch (e) {
        debugPrint("error! code: ${e.code} - message: ${e.message}");
      }
    }
  }
}
