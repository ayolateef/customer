import 'package:courierx/main.dart';
import 'package:courierx/model/account.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_launch/flutter_launch.dart';

class WhatsappLink extends StatefulWidget {
  const WhatsappLink({Key? key}) : super(key: key);

  @override
  State<WhatsappLink> createState() => _WhatsappLinkState();
}

class _WhatsappLinkState extends State<WhatsappLink> {
  // @override
  // void initState() {
  //   super.initState();
  //   getUserNameAndPassword();
  // }
  //
  // String getUserNameAndPassword(){
  //   var name  = account.userName;
  //   var email = account.userName;
  //   var message = "Hi, My Name is $name with email: $email";
  //   return message;
  // }

  _onChatClick() async {
    print("wechat");
    // bool whatsapp = await FlutterLaunch.hasApp(name: "Whatsapp");
    // print(whatsapp);
    try {
      print("chatWhatsapp");
      // await FlutterLaunch.launchWhatsapp(
      //     phone: "2348186014986", message: "Hi admin, ");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: new Text("Something Went Wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Chat with one of our customer care representatives through our whatsapp line below:',
              style: theme.text16bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: _onChatClick,
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset("assets/whatsapp1.png")),
            )
          ],
        ),
      ),
    );
  }
}
