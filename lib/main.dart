
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:face_detection_with_firebase/drawer_and_appbar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'ad_manager.dart';
import 'camera_preview_scanner.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final String appId = 'httpdjfakl';
  bool animationFinished = false;

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerAndAppBar().drawer(),
      appBar: DrawerAndAppBar().appBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blueGrey,
        child: animationFinished ? mainScreen():animatedText(),
      ),
    );
  }

  Widget mainScreen(){
    return Stack(
      children: [
        Image.asset('assets/avatar.png',fit: BoxFit.cover,),
        Positioned(

            child: Text('Sad',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 40.0),)),
        Positioned(
            right: 1.0,
            child: Text('Normal',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 40.0),)),
        Positioned(
            top: 220,
            left: 1.0,
            child: Text('Happy',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 40.0),)),
        Positioned(
            top: 220,
            right: 1.0,
            child: Text('Excellent',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 40.0),)),
        Positioned(
          left: 120.0,
          bottom: 80.0,
          child: RaisedButton(
            color: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            child: Text('Start',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40.0),),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CameraPreviewScanner())),
          ),
        ),
      ],
    );
  }

  Widget animatedText(){
    return Center(
      child: SizedBox(
        width: 250.0,
        child: TypewriterAnimatedTextKit(
          speed: Duration(milliseconds: 100),
          isRepeatingAnimation: false,
          onFinished: (){
            setState(() {
              animationFinished = true;
            });
          },
          text: [
            "Real Time Face Analyzer",
          ],
          textStyle: TextStyle(
              fontSize: 40.0,
              fontFamily: "Agne"
          ),
        ),
      ),
    );
  }
}
