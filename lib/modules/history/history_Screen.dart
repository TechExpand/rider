import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/themes.dart';
import 'package:riderapps/modules/rating/rating_screen.dart';
import 'package:riderapps/modules/widgets/cardWidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var UserId = FirebaseAuth.instance.currentUser?.uid;
  List lists = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            color: Theme.of(context).primaryColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top + 16,
              ),
              Padding(
                padding: EdgeInsets.only(right: 14, left: 14),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.only(right: 14, left: 14, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('History'),
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:   FutureBuilder(
                  future:  FirebaseDatabase.instance.reference().child('rideRequestHistory/$UserId').once(),
                  builder: (BuildContext context,  snapshot) {
                    if(snapshot.hasData && snapshot.data != null){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }else{
                        lists.clear();
                        // print( snapshot.data.value);
                         Map<dynamic, dynamic> ?values;
                        values = snapshot.data as Map;
                        values.values.forEach((values) {
                           lists.add(values);
                        });


                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: lists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(top: 0, right: 14, left: 14),
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        //   gotorating();  destination_address   status
                                      },
                                      child: CardWidget(
                                        fromAddress: lists[index]['pickup_address'],
                                        toAddress: lists[index]['destination_address'],
                                        price: lists[index]['amount'],
                                        status: lists[index]['status'],
                                        time: lists[index]["created_at"],
                                        statusColor: HexColor("#3638FE"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    }else if (snapshot.hasError){
                      return Center( // here only return is missing
                          child: Text('No data')
                      );
                    }
                    return Center( // here only return is missing
                        child: Text('No data')
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}