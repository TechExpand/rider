import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:riderapps/modules/home/locationButton.dart';
import 'package:riderapps/modules/home/search.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:riderapps/modules/home/requset_view.dart';
import 'package:riderapps/modules/home/home_screen.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:riderapps/modules/helper/helperMethod.dart';
import 'package:provider/provider.dart';
import 'package:riderapps/widgets/ProgressDialog.dart';
import 'package:riderapps/modules/dataProviders/appData.dart';
import 'package:riderapps/modules/helper/request_helper.dart';
import 'package:riderapps/modules/datamodels/prediction.dart';
import 'package:riderapps/modules/datamodels/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riderapps/main.dart'  as main;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

List<Prediction> notes = [];
late final lati;
 late final longi;
 late final  addressCurrent;

class AddressSelctionView extends StatefulWidget {
  final  animationController;
  final  isUp, isSerchMode;
  final  onUp, onSerchMode;
  final  serachController;
  final  mapCallBack, gpsClick, getDirection;
  const AddressSelctionView(
      {
        this.animationController,
        this.isUp,
        this.onUp,
        this.isSerchMode,
        this.onSerchMode,
        this.serachController,
        this.mapCallBack,
        this.getDirection,
        this.gpsClick});
  @override
  _AddressSelctionViewState createState() => _AddressSelctionViewState();
}

class _AddressSelctionViewState extends State<AddressSelctionView> {
 late Position currentPosition;
  var pickupController = new TextEditingController();
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  void setUpGeolocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    lati = currentPosition.latitude;
    longi = currentPosition.longitude;
    addressCurrent = await helperMthod.findCoordinateAddress(position, context);
    pickupController.text = addressCurrent;
  }
  void placeSearch(String placeName) async {
    if (placeName.length > 1) {
      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyCH1M_2GJ66XvaE0s5xsc7GGgEtUU2v4kQ&sessiontoken=123675767686694567890&components=country:ng';
      var response = await RequestHelper.getRequest(url);
      if (response == 'failed') {
        return;
      }
      if (response['status'] == 'OK') {
        var predictionJson = response['predictions'];
        var thisList = (predictionJson as List).map((e) =>
            Prediction.fromJson(e)).toList();
        setState(() {
          notes = thisList;
        });
      }
    }
  }

  void getPlaceDetails(String placeID, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=AIzaSyCH1M_2GJ66XvaE0s5xsc7GGgEtUU2v4kQ';
    var response = await RequestHelper.getRequest(url);
    Navigator.pop(context);
    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeId = placeID;
      thisPlace.latitude = response ['result']['geometry']['location']['lat'];
      thisPlace.longitude = response ['result']['geometry']['location']['lng'];
      await prefs.setString('dplaceName', thisPlace.placeName);
      await prefs.setString('dplaceId', thisPlace.placeId);
      await prefs.setDouble('dLatitude', thisPlace.latitude);
      await prefs.setDouble('dLongitude', thisPlace.longitude);
      widget.getDirection();
      //  _HomeScreenState().getDirection();
    }
  }

  @override
  void initState() {
    setUpGeolocation();
    super.initState();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var response = await Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchPage()
        ));
        if (response == 'getDirection') {
          widget.getDirection();
        }
      },
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(),
              ),
              LocationButtonView(
                gpsClick: () {
                  widget.gpsClick();
                },
              ),
              SizedBox(
                height: 120,
              ),
            ],
          ),
          AnimatedBuilder(
            animation: widget.animationController,
            builder: (BuildContext context, Widget ?child) {
              return Transform(
                transform: new Matrix4.translationValues(
                    0.0,
                    100 +
                        (((MediaQuery
                            .of(context)
                            .size
                            .height - 220))) *
                            ((AlwaysStoppedAnimation(
                                Tween(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: widget.animationController,
                                        curve: Curves.fastOutSlowIn)))
                                .value)
                                .value),
                    0.0),
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onVerticalDragUpdate: (
                            DragUpdateDetails gragEndDetails) {
                          if (gragEndDetails.delta.dy > 0) {
                            widget.onUp(false);
                          } else if (gragEndDetails.delta.dy < 0) {
                            widget.onUp(true);
                          }
                          final position = gragEndDetails.globalPosition.dy
                              .clamp(0, (MediaQuery
                              .of(context)
                              .size
                              .height - 220) + MediaQuery
                              .of(context)
                              .padding
                              .bottom) +
                              36 +
                              gragEndDetails.delta.dy;
                          final animatedPostion =
                              (position - 100) / ((MediaQuery
                                  .of(context)
                                  .size
                                  .height - 220) + MediaQuery
                                  .of(context)
                                  .padding
                                  .bottom);
                          widget.animationController.animateTo(
                              animatedPostion, duration: Duration(
                              milliseconds: 0));
                        },
                        onVerticalDragEnd: (DragEndDetails gragEndDetails) {
                          if (widget.isUp) {
                            widget.onSerchMode(true);
                            widget.animationController.animateTo(0,
                                duration: Duration(milliseconds: 240));
                          } else {
                            widget.onSerchMode(false);
                            widget.animationController.animateTo(1,
                                duration: Duration(milliseconds: 240));
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Theme
                                  .of(context)
                                  .cardColor,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme
                                          .of(context)
                                          .disabledColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: 3,
                                      width: 48,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: Theme
                                  .of(context)
                                  .cardColor,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 4, right: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Text(AppLocalizations.of(
                                                'Current Location'),
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .caption),
                                            SizedBox(height: 4),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFEEEEEE),
                                                borderRadius: BorderRadius
                                                    .circular(4),
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    addressCurrent != null
                                                        ? addressCurrent
                                                        : 'Loading',
                                                    style: TextStyle(
                                                        color: Theme
                                                            .of(context)
                                                            .disabledColor),
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, top: 8, bottom: 8, right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(AppLocalizations.of('Drop-off'),
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .caption),
                                    SizedBox(height: 4),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFEEEEEE),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: widget.serachController,
                                          enabled: widget.isSerchMode,
                                          onChanged: (value) {
                                            placeSearch(value);
                                          },
                                          cursorColor: Theme
                                              .of(context)
                                              .primaryColor,
                                          decoration: InputDecoration(
                                              hintText: 'Set Destination location',
                                              fillColor: Color(0xFFEEEEEE),
                                              filled: true,
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 10, top: 8, bottom: 8)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if (widget.isSerchMode) {
                                        widget.onSerchMode(false);
                                        widget.animationController.animateTo(1,
                                            duration: Duration(
                                                milliseconds: 240));
                                      } else {
                                        widget.onSerchMode(true);
                                        widget.animationController.animateTo(0,
                                            duration: Duration(
                                                milliseconds: 240));
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        widget.isSerchMode ? Icons.close : Icons
                                            .search,
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .headline4
                                            !.color,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: Theme
                                        .of(context)
                                        .dividerColor,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      widget.mapCallBack();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.map,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Opacity(
                        opacity: 1.0 - widget.animationController.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              color: Theme
                                  .of(context)
                                  .dividerColor
                                  .withOpacity(0.05),
                              height: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Text(
                                  AppLocalizations.of('POPULAR LOCATONS'),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .caption),
                            ),
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height - 230,
                              child: ListView.builder(
                                padding: EdgeInsets.all(0.0),
                                itemCount: notes.length,
                                itemBuilder: (context, idx) {
                                  return FlatButton(
                                    onPressed: () {
                                      getPlaceDetails(
                                          notes[idx].placeId, context);
                                    },
                                    padding: EdgeInsets.all(0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(width: 22,
                                                  height: 22,
                                                  child: Image.asset(
                                                      ConstanceData.endPin)),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      4.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              notes[idx]
                                                                  .mainText,
                                                              style: Theme
                                                                  .of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              notes[idx]
                                                                  .secondaryText,
                                                              style: Theme
                                                                  .of(context)
                                                                  .textTheme
                                                                  .bodyText2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 1,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
