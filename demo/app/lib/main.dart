import 'dart:developer';

import 'package:app/widgets/primary_input_field.dart';
import 'package:app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'demo_method_channel.dart';
import 'views/dashboard.dart';

final WalletSDKPlugin = MethodChannelWallet();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WalletSDKPlugin.initSDK();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light, // 2
          automaticallyImplyLeading:false,
          title: Image.asset('lib/assets/images/logo.png',    fit: BoxFit.contain,
            height: 24, width: 144.6,),
          backgroundColor: const Color(0xffEEEAEE),
          flexibleSpace: Container(
            height: 130,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('lib/assets/images/glow.png'),
                  opacity: 0.6,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fill,
                ),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xff100716),
                      Color(0xff261131),
                    ])
            ),
          ),
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('lib/assets/images/background.png'),
                alignment: Alignment.topLeft
              ),
            ),
            child: const MainWidget(),
        ),
        backgroundColor: const Color(0xffF4F1F5),
      ),
      debugShowCheckedModeBanner: false, //Removing Debug Banner
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var userDIDId = '';

  Future<String?> _createDid() async {
    var didID = await WalletSDKPlugin.createDID();
    setState(() {
      userDIDId = didID!;
    });
    log("created didID :$didID");
    return didID;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: const Text('Trustbloc Sign In',
                  textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'SF Pro' )),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: PrimaryInputField(textController: _usernameController, titleTextAlign: TextAlign.center, labelText: 'Username',),
            ),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child:   PrimaryButton(
                  width: double.infinity,
                  onPressed: () async {
                    final SharedPreferences pref = await prefs;
                    String? userLoggedIn =  pref.getString("userLoggedIn");
                    if (_usernameController.text == userLoggedIn.toString()){
                      _navigateToDashboard();
                    } else {
                      await _createDid();
                      pref.setString('userLoggedIn', _usernameController.text);
                      pref.setString('userDID', userDIDId);
                      _navigateToDashboard();
                    }
                  },
                  child: const Text('Sign In ', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: const Text('This is a reference app and not to be used for production use cases.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'SF Pro', color: Color(0xff6C6D7C) )),
            ),

          ],
        )
      );
  }
  _navigateToDashboard() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const  Dashboard()));
  }
}
