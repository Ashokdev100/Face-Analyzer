import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerAndAppBar{
  final appId = 'https://play.google.com/store/apps/details?id=com.cooldeveloper.faceanalyzer';
  final privacyPolicy = 'https://sites.google.com/view/faceanalyzer';
  final otherApps = 'https://play.google.com/store/apps/collection/cluster?clp='
      'igNCChkKEzc4NDU0MDIzMDUwMTc1Mzk4MTYQCBgDEiMKHWNvbS5jb29sZGV2ZWxvcGVyLm1vYmlsZW11c2ljEAEYAxgB:'
      'S:ANO1ljJQFWQ&gsr=CkWKA0IKGQoTNzg0NTQwMjMw'
      'NTAxNzUzOTgxNhAIGAMSIwodY29tLmNvb2xkZXZlbG9wZXIubW9iaWxlbXVzaWMQARgDGAE%3D:S:ANO1ljJXffA';


  Widget drawer(){
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            //padding: EdgeInsets.only(bottom: 5),
            child: Center(
              child: Text(
                'Face Analyzer',
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            )
          ),
          SizedBox(height: 40.0),
          Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(Icons.rate_review,size: 40.0,color: Colors.blue,),
            title: Text('Feedback',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            onTap: () => _launchURL(appId),
          ),
          Divider(color: Colors.deepPurple,),
          SizedBox(height: 20.0),
          Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(Icons.security,size: 40.0,color: Colors.blue,),
            title: Text('Privacy policy',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            onTap: () => _launchURL(privacyPolicy),
          ),
          Divider(color: Colors.deepPurple,),
          SizedBox(height: 20.0),
          Divider(color: Colors.deepPurple,),
          ListTile(
            leading: Icon(Icons.apps,size: 40.0,color: Colors.blue,),
            title: Text('Other Apps',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            onTap: () => _launchURL(otherApps),
          ),
          Divider(color: Colors.deepPurple,),
        ],
      ),
    );
  }

  Widget appBar(){
    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Face Analyzer'),
            IconButton(
              icon: Icon(Icons.share,size: 30.0,color: Colors.white,),
              onPressed: () => Share.share('$appId'),
            ),
          ],
        )
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}