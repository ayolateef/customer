import 'dart:io';

import 'package:courierx/model/account.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:courierx/model/ChatMessage.dart';
import 'package:courierx/model/chatmessagedto.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/servicelocator.dart';
import 'package:intl/intl.dart';
// import 'package:android_intent_plus/android_intent.dart' as android_intent;
// import 'package:android_intent_plus/flag.dart' as android_action;

//import 'package:flutter_launch/flutter_launch.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

// final socketUrl =
//     'https://ec2-13-59-232-253.us-east-2.compute.amazonaws.com:30122/websocket-chat';

class _ChatDetailPageState extends State<ChatDetailPage> {
  // RestDataService _restdataService = serviceLocator<RestDataService>();
  // List<ChatMessage> messages = [];
  //
  // StompClient stompClient;
  //
  // String message = "";
  // String username = "";
  //
  // var editControllerMsg = TextEditingController();

  // getmessages(String token) async {
  //   String adminusername =
  //       Provider.of<AccountViewModel>(context, listen: false).adminuser;
  //   String username =
  //       Provider.of<CreateAccountViewModel>(context, listen: false)
  //           .logonusername;
  //   String url =
  //       "https://ec2-13-59-232-253.us-east-2.compute.amazonaws.com:30122/messages/all/" +
  //           username +
  //           "/admin";
  //   print("got herw");
  //   messages = await _restdataService.getmessage(token, url);
  //   print("got herw 2");
  //   print(messages);
  //   setState(() {
  //     messages = messages;
  //   });
  // }

  // Future<List<ChatMessage>> getChat() async {
  //   if (this.mounted) {
  //     String adminusername =
  //         Provider.of<AccountViewModel>(context, listen: false).adminuser;
  //     String username =
  //         Provider.of<CreateAccountViewModel>(context, listen: false)
  //             .logonusername;
  //     String token =
  //         Provider.of<CreateAccountViewModel>(context, listen: false).token;
  //     print("Admin $adminusername");
  //     String url =
  //         "https://ec2-13-59-232-253.us-east-2.compute.amazonaws.com:30122/messages/all/" +
  //             username +
  //             "/admin";
  //     print("got herw");
  //
  //     messages = await _restdataService.getmessage(token, url);
  //     print(messages.length);
  //     setState(() {});
  //     return messages;
  //   }
  // }

  // _launchURL() async {
  //   // Replace 12345678 with your tel. no.
  //   String phone =
  //       Provider.of<AccountViewModel>(context, listen: false).adminphone;
  //
  //   var uri = 'tel:${phone}';
  //   if (await canLaunch(uri)) await launch(uri);
  // }

  // Stream<List<ChatMessage>> getNumbers(Duration refreshTime) async* {
  //   if (!mounted) return;
  //
  //   if (this.mounted) {
  //     while (true) {
  //       await Future.delayed(refreshTime);
  //       yield await getChat();
  //     }
  //   }
  // }

  // initClient(String token) async {
  //   try {
  //     if (stompClient != null && stompClient.connected) {
  //       print("already connected");
  //       return;
  //     }
  //     if (stompClient == null) {
  //       //  stompClient.deactivate();
  //       stompClient = StompClient(
  //         config: StompConfig.SockJS(
  //           url: socketUrl,
  //           stompConnectHeaders: {
  //             'Authorization': 'Bearer $token', // please note <<<<<
  //           },
  //           webSocketConnectHeaders: {
  //             'Authorization': 'Bearer $token', // please note <<<<<
  //           },
  //           onStompError: (StompFrame frame) {
  //             print(
  //                 'A stomp error occurred in web socket connection :: ${frame.body}');
  //           },
  //           onWebSocketError: (dynamic frame) {
  //             print(
  //                 'A Web socket error occurred in web socket connection :: ${frame.toString()}');
  //           },
  //           onDebugMessage: (dynamic frame) {
  //             print(
  //                 'A debug error occurred in web socket connection :: ${frame.toString()}');
  //           },
  //           onConnect: onConnect,
  //           heartbeatIncoming: Duration(seconds: 3),
  //         ),
  //       );
  //
  //       stompClient.activate();
  //       print("stomp connected");
  //       print(stompClient.connected);
  //     }
  //   } catch (e) {
  //     print('An error occurred ${e.toString()}');
  //   }
  // }

  // void onConnect(StompFrame frame) {
  //   StompClient client;
  //   String url = "/topic/chat";
  //   print("subscribe 1");
  //   client.subscribe(
  //     destination: url,
  //     callback: (StompFrame frame) {
  //       print("Check frame");
  //       if (frame.body != null) {
  //         List<dynamic> result = json.decode(frame.body);
  //         print("frame body not null");
  //         List<ChatMessage> values = new List<ChatMessage>();
  //         if (result.length > 0) {
  //           for (int i = 0; i < result.length; i++) {
  //             ChatMessage notify = ChatMessage.fromJson(result[i]);
  //             print("message 1");
  //             values.add(notify);
  //           }
  //         }
  //
  //         //     print(result['messages']);
  //         //     setState(() => messages = values);
  //       }
  //     },
  //   );
  // }
  late Account account;

  @override
  void initState() {
    super.initState();
    getUserNameAndPassword();
  }

  String getUserNameAndPassword() {
    var name = account.userName;
    var email = account.userName;
    var message = "Hi, My Name is $name with email: $email";
    return message;
  }

  String phone = "+2348186014986";
  _openWhatsapp() async {
    var whatsapp = phone; //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=" +
        whatsapp +
        "&text=${getUserNameAndPassword.toString()}";
    var whatsappURLIos =
        "https://wa.me/$whatsapp?text=${Uri.tryParse(getUserNameAndPassword.toString())}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // String token =
  //   //     Provider.of<CreateAccountViewModel>(context, listen: false).token;
  //   // initClient(token);
  //   //  getmessages(token);
  // }

  // @override
  // void dispose() {
  //   // stompClient.deactivate();
  //   super.dispose();
  // }

  // _sendClientMessage() async {
  //   var now = new DateTime.now();
  //   var formatter = new DateFormat('yyyy-MM-dd');
  //
  //   String formattedDate = formatter.format(now);
  //   String adminusername = "admin";
  //   //     Provider.of<AccountViewModel>(context, listen: false).adminuser;
  //   String username =
  //       Provider.of<CreateAccountViewModel>(context, listen: false)
  //           .logonusername;
  //   ChatRequestDTO2 chatRequestDTO2 = new ChatRequestDTO2(
  //       username, adminusername, editControllerMsg.text, formattedDate);
  //   print(editControllerMsg.text);
  //   print("stomp connected");
  //   print(stompClient.connected);
  //   if (stompClient != null && stompClient.connected) {
  //     stompClient.send(
  //         destination: '/app/chat',
  //         body: jsonEncode(chatRequestDTO2.toJson()),
  //         headers: {});
  //     setState(() {
  //       editControllerMsg.clear();
  //     });
  //   } else {
  //     // stompClient.activate();
  //     print(editControllerMsg.text);
  //     print("stomp connected2");
  //     print(stompClient.connected);
  //   }
  // }

  // _callNumber(String phoneNumber) async {
  //   String number = phoneNumber;
  //   await FlutterPhoneDirectCaller.callNumber(number);
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _openWhatsapp,
        child: Container(
          height: 20,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Text('Reach the Admin through our whatsapp contact'),
              SizedBox(
                width: 20,
              ),
              Image.asset('assets/chat.png', fit: BoxFit.fill)
            ],
          ),
        ),
      ),
    );
  }
}

// Stack(
// children: <Widget>[
// Container(
// margin:
// EdgeInsets.only(top: MediaQuery.of(context).padding.top + 38),
// child: Scaffold(
// appBar: AppBar(
// elevation: 0,
// automaticallyImplyLeading: false,
// backgroundColor: Colors.white,
// flexibleSpace: SafeArea(
// child: Container(
// padding: EdgeInsets.only(right: 16),
// child: Row(
// children: <Widget>[
// SizedBox(
// width: 20,
// ),
// CircleAvatar(
// backgroundImage: AssetImage("assets/5.jpg"),
// maxRadius: 20,
// ),
// SizedBox(
// width: 12,
// ),
// Expanded(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.center,
// children: <Widget>[
// Text(
// "Admin",
// style: TextStyle(
// fontSize: 16, fontWeight: FontWeight.w600),
// ),
// SizedBox(
// height: 6,
// ),
// Text(
// "Online",
// style: TextStyle(
// color: Colors.grey.shade600, fontSize: 13),
// ),
// ],
// ),
// ),
// IconButton(
// onPressed: () {
// _launchURL();
// },
// icon: Icon(
// Icons.phone,
// color: Colors.black,
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// body: StreamBuilder(
// stream: getNumbers(Duration(seconds: 2)),
// initialData: messages,
// // ignore: missing_return
// builder: (context, stream) {
// if (stream.connectionState == ConnectionState.done) {
// return Icon(
// Icons.check_circle,
// color: Colors.green,
// size: 20,
// );
// }
// if (stream.hasData) {
// messages = stream.data;
//
// return Stack(
// children: <Widget>[
// ListView.builder(
// itemCount: messages.length,
// shrinkWrap: true,
// padding: EdgeInsets.only(top: 10, bottom: 120),
// physics: const BouncingScrollPhysics(
// parent: AlwaysScrollableScrollPhysics()),
// primary: false,
// scrollDirection: Axis.vertical,
// itemBuilder: (context, index) {
// return Container(
// padding: EdgeInsets.only(
// left: 14, right: 14, top: 10, bottom: 10),
// child: Align(
// alignment:
// (messages[index].messageType == "receiver"
// ? Alignment.topLeft
//     : Alignment.topRight),
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(20),
// color: (messages[index].messageType ==
// "receiver"
// ? Colors.grey.shade200
//     : Colors.blue[200]),
// ),
// padding: EdgeInsets.all(16),
// child: Text(
// messages[index].messageContent,
// style: TextStyle(fontSize: 15),
// ),
// ),
// ),
// );
// },
// ),
// // SizedBox(
// //   height: 200,
// // ),
// Align(
// alignment: Alignment.bottomLeft,
// child: Container(
// padding: EdgeInsets.only(
// left: 10, bottom: 10, top: 10),
// height: 60,
// margin: const EdgeInsets.only(bottom: 60.0),
// width: double.infinity,
// color: Colors.white,
// child: Row(
// children: <Widget>[
// GestureDetector(
// onTap: () {},
// child: Container(
// height: 30,
// width: 30,
// decoration: BoxDecoration(
// color: Colors.lightBlue,
// borderRadius: BorderRadius.circular(30),
// ),
// child: Icon(
// Icons.add,
// color: Colors.white,
// size: 20,
// ),
// ),
// ),
// SizedBox(
// width: 15,
// ),
// Expanded(
// child: TextField(
// controller: editControllerMsg,
// decoration: InputDecoration(
// hintText: "Write message...",
// hintStyle:
// TextStyle(color: Colors.black54),
// border: InputBorder.none),
// ),
// ),
// SizedBox(
// width: 15,
// ),
// FloatingActionButton(
// onPressed: () {
// _sendClientMessage();
// },
// child: Icon(
// Icons.send,
// color: Colors.white,
// size: 18,
// ),
// backgroundColor: Colors.blue,
// elevation: 0,
// ),
// ],
// ),
// ),
// ),
// ],
// );
// }
// }),
// ))
// ],
// )
