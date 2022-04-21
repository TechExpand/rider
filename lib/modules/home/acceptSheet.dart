import 'package:flutter/material.dart';
import 'package:riderapps/constance/global.dart' as globals;
import 'package:riderapps/modules/datamodels/nearbydriver.dart';
import 'package:riderapps/widgets/BrandDivier.dart';
import 'package:riderapps/widgets/NoDriverDialog.dart';
import 'package:riderapps/widgets/brand_colors.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:cached_network_image/cached_network_image.dart';

late Position currentPosition;

class AcceptView extends StatefulWidget {
  final  reset;
  final carDetails;
  final driverFullName;
  final driverPhoneNumber;
  final tripStatusDisplay;
  final  endRide;
  final photoUrl;
  final driverCarNumber;

  const AcceptView(
      {this.carDetails, this.driverFullName, this.driverPhoneNumber, this.tripStatusDisplay, this.reset, this.endRide, this.photoUrl, this.driverCarNumber});

  @override
  _AcceptViewState createState() => _AcceptViewState();
}

class _AcceptViewState extends State<AcceptView>
    with TickerProviderStateMixin {
  double searchSheetHeight = 300;
  double rideDetailsSheetHeight = 0; // (Platform.isAndroid) ? 235 : 260
  double requestingSheetHeight = 0; // (Platform.isAndroid) ? 195 : 220
  double tripSheetHeight = 278;
  late List<NearbyDriver> availableDrivers;
  String appState = 'NORMAL';
  int driverRequestTimeout = 30;
  late StreamSubscription rideSubscription;
  String accept = 'Normal';
  var status = '';
  var driverFullName = '';
  var driverPhoneNumber = '';
  var driverCarDetails = '';
  var tripStatusDisplay = 'Driver is Arriving';
  late DatabaseReference rideRef;
  late DatabaseReference reffed;

  // (Platform.isAndroid) ? 275 : 300
  bool isRequestingLocationDetails = false;

  void cancelRequest() {
    widget.reset();
  }

  _callNumber() async {
    var number = widget.driverPhoneNumber; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  void setUpGeolocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
  }

  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverDialog()
    );
  }

  void findDriver() {}


    @override
    Widget build(BuildContext context) {
      return Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 0.5, //extend the shadow
                      offset: Offset(
                        0.7, // Move to right 10  horizontally
                        0.7, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                height: tripSheetHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.tripStatusDisplay,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Brand-Bold'),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      BrandDivider(),
                      SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.driverFullName, style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold,),),
                                SizedBox(height: 5,),
                                Text(widget.carDetails, style: TextStyle(
                                    color: BrandColors.colorTextLight),),
                                SizedBox(height: 5,),
                                Text(widget.driverCarNumber, style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold,),),
                              ]),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: widget.photoUrl,
                              height: 85,
                              width: 75,
                              placeholder: (context,
                                  url) => new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              new Icon(Icons.error, size: 40.0,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      BrandDivider(),
                      SizedBox(height: 11,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print('Getting');
                                  _callNumber();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular((25))),
                                    border: Border.all(width: 1.0,
                                        color: BrandColors.colorTextLight),
                                  ),
                                  child: Icon(Icons.call),
                                ),
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                  onTap: () {
                                    print('Getting');
                                    _callNumber();
                                  },
                                  child: Text('Call')
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular((25))),
                                  border: Border.all(width: 1.0,
                                      color: BrandColors.colorTextLight),
                                ),
                                child: Icon(Icons.list),
                              ),
                              SizedBox(height: 10,),
                              Text('Details'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  widget.endRide();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular((25))),
                                    border: Border.all(width: 1.0,
                                        color: BrandColors.colorTextLight),
                                  ),
                                  child: Icon(Icons.clear),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Cancel'),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }
}

