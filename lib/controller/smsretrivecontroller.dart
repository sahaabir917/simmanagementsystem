import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simcardmangment/helper/api_helper.dart';
import 'package:simcardmangment/helper/preference_helper.dart';
import 'package:simcardmangment/model/failed_model.dart';
import 'package:simcardmangment/model/message_model.dart';
import 'package:simcardmangment/utils/common_utils.dart';
import 'package:sms_plugin/sms.dart';
import 'package:sms_plugin/sms.dart' as smspackage;

class SmsRetriveController extends GetxController {
  PreferenceHelper preferenceHelper = PreferenceHelper();
  CommonUtils commonUtils = CommonUtils();
  ApiHelper apiHelper = ApiHelper();
  var accessToken = "".obs;
  var messages =MessageModel().obs;
  var messageIds = "".obs;

  @override
  void onInit() {}

  Future<void> saveToken(String token) async {
    preferenceHelper.setToken(token);
    accessToken(token);
  }

  Future<void> getMessages() async {
    messageIds("");
    var token = await commonUtils.getAccessToken();
    print("accesstoken in controller ${token}");
    var response = await apiHelper.getMessages(token);
    if (response is MessageModel) {
      print("message model okay");
      messages(response);
      messages.refresh();
      var lengthofMessage = messages.value.data.length;
      for(int i=0;i<lengthofMessage;i++){
          if(i ==0){
           var message = messages.value.data[i].id.reactive.value;
           print("values are : "+messages.value.data[i].id.reactive.value);
           messageIds = "${message}".obs;
           print("message ids are : ${messageIds.value}");
         }
         else if(i == lengthofMessage-1){
            print("values are : "+messages.value.data[i].id.reactive.value);
            var message = messages.value.data[i].id.reactive.value;
            messageIds = "${messageIds.value},${message}".obs;
            print("message ids are : ${messageIds.value}");
          }
         else{
           var message = messages.value.data[i].id.reactive.value;
           print("values are : "+messages.value.data[i].id.reactive.value);
           messageIds = "${messageIds.value},${message}".obs;
           print("message ids are : ${messageIds.value}");
         }
      }
      if(lengthofMessage>0){

           updateMessageStatus(messageIds.value);

      }
      print("message ids are : ${messageIds.value}");
    }
    else if(response is FailedModel){
      await Future.delayed(const Duration(seconds: 10), () async {
       await getAgainMessages();
      });
    }
  }

  void getAgainMessages() async {
    messageIds("");
    var token = await commonUtils.getAccessToken();
    print("accesstoken in controller ${token}");
    var response = await apiHelper.getMessages(token);
    if (response is MessageModel) {
      print("message model okay");
      messages(response);
      messages.refresh();
      var lengthofMessage = messages.value.data.length;
      for (int i = 0; i < lengthofMessage; i++) {
        if (i == 0) {
          var message = messages.value.data[i].id.reactive.value;
          print("values are : " + messages.value.data[i].id.reactive.value);
          messageIds = "${message}".obs;
          print("message ids are : ${messageIds.value}");
        }
        else if (i == lengthofMessage - 1) {
          print("values are : " + messages.value.data[i].id.reactive.value);
          var message = messages.value.data[i].id.reactive.value;
          messageIds = "${messageIds.value},${message}".obs;
          print("message ids are : ${messageIds.value}");
        }

        else {
          var message = messages.value.data[i].id.reactive.value;
          print("values are : " + messages.value.data[i].id.reactive.value);
          messageIds = "${messageIds.value},${message}".obs;
          print("message ids are : ${messageIds.value}");
        }
      }
      if(lengthofMessage>0){
           updateMessageStatus(messageIds.value);
      }
      var lengthofMessages = messages.value.data.length;
      print("length of message list is : ${lengthofMessages}");
      for (int i = 0; i < lengthofMessage; i++) {
        print("sending msg id is : " + messages.value.data[i].id);
        printSimCardsDatas(messages.value.data[i].message,
            messages.value.data[i].phoneNumber, i, lengthofMessage);
      }
      print("message ids are : ${messageIds.value}");
    }
    else if(response is FailedModel){
      print("call agin without timer");
      await Future.delayed(const Duration(seconds: 10), () async {
        await getAgainMessages();
      });
    }
  }

  Future<void> printSimCardsDatas(String messageText, String phoneNumber,
      int messageNumber, int totalNumber) async {
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
    if (status.isGranted && status1.isGranted) {
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
            if (messageNumber == totalNumber - 1) {
              print("call again getmessage api");
              // smsRetriveController.getMessages();
              // await Future.delayed(const Duration(seconds: 10), () async {
              //  await  getAgainMessages();
              // });
            }
          }
        });

        print(
            "message number is : ${messageNumber} and total number is ${totalNumber - 1}");
      } on PlatformException catch (e) {
        debugPrint("error! code: ${e.code} - message: ${e.message}");
      }
    }
  }

Future<void> updateMessageStatus(String value) async{
  print("messageIds are ${value}");
  var token = await commonUtils.getAccessToken();
   apiHelper.updateMessageStatus(value,token);
}


}
