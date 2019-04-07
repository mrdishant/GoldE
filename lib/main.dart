import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());
final colorPrimary = const Color(0xFF7966FF);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold Price',
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  String goldPrice = "", sellPrice = "";
  DateTime lastUpdate = DateTime.now();

  @override
  void initState() {
    getGoldPrice();
    if (Platform.isIOS)
      FirebaseMessaging().requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
    FirebaseMessaging().subscribeToTopic('drop');
    FirebaseMessaging().subscribeToTopic('rise');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//        color: colorPrimary,
        decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage("back.jpg"), fit: BoxFit.cover),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                  color: Colors.white,
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        Card(
                          color: Colors.green,
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Live Gold Price",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "GoogleSansBold"),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text(
                          "Buying Price (per gram)",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12.0,
                              fontFamily: "GoogleSansRegular"),
                        ),
                        Text(
                          "₹ " + goldPrice,
                          style: TextStyle(
                              color: colorPrimary,
                              fontSize: 20.0,
                              fontFamily: "GoogleSansRegular"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text(
                          "Selling Price (per gram)",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12.0,
                              fontFamily: "GoogleSansRegular"),
                        ),
                        Text(
                          "₹ " + sellPrice,
                          style: TextStyle(
                              color: colorPrimary,
                              fontSize: 20.0,
                              fontFamily: "GoogleSansRegular"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text(
                          "Last Updated : " +
                              DateFormat("E, dd MMM yyyy HH:mm:ss ")
                                  .format(lastUpdate) +
                              "\n\nGOLDE will Alert you When There is a Drop or Rise in Price.\n\nBy Dishant Mahajan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0,
                              fontFamily: "GoogleSansRegular"),
                        )
                      ]))),
            ]));
  }

  void getGoldPrice() {
    Firestore.instance
        .collection("GoldPrice")
        .document("GoldPrice")
        .snapshots()
        .listen((doc) {
      goldPrice =
          double.parse(doc.data['price_per_gm'].toString()).toStringAsFixed(2);
      sellPrice = double.parse(doc.data['sell_price_per_gm'].toString())
          .toStringAsFixed(2);
      lastUpdate = doc.data['lastUpdate'];
      setState(() {});
    });
  }
}
