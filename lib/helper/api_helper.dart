import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:simcardmangment/model/failed_model.dart';
import 'package:simcardmangment/model/message_model.dart';
class ApiHelper{
  static var client = http.Client();
  MessageModel messageModel = MessageModel();
  FailedModel failedModel = FailedModel();

  Future<dynamic> getMessages(
      String token) async {

    try{
      print("http://iftakhar.me/smsblaster/getmessage?key=${token}");
      var response = await client.get(
        Uri.parse("http://iftakhar.me/smsblaster/getmessage?key=${token}"),
        headers: {
          "Content-Type": "application/json",
        },
      );
      print("message reponse ${response.body}");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body) as Map<String, dynamic>;
        print("result code is : ${result["code"]}");
        if (result["code"] == 9) {
          failedModel = failedModelFromJson(response.body);
          return failedModel;
        }
        else if(result["code"] == 0){
          messageModel = messageModelFromJson(response.body);
          return messageModel;
        }

      }
    } on SocketException{
      print("socket exception");
    }
    on Error catch (e) {
      print('Error: $e');
    }
    on TimeoutException catch (e) {
     print("timeout exception");
    }


  }

  Future<void> updateMessageStatus(String value,String token) async{

    try{
      print("http://iftakhar.me/smsblaster/updatemessagestatus?key=${token}");
      var body = {"updateids": value};
      print("body is ${body}");
      var response = await client.post(
          Uri.parse("http://iftakhar.me/smsblaster/updatemessagestatus?key=${token}"),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode(body)
      );
      print("updatemessagestatus response : ${response.body}");
    }on SocketException{
      print("socket exception");
    }
    on Error catch (e) {
      print('Error: $e');
    }
    on TimeoutException catch (e) {
      print("timeout exception");
    }



    // if (response.statusCode == 200) {
    //   messageModel = messageModelFromJson(response.body);
    //   return messageModel;
    // }
  }

}