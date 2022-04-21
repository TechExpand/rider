import 'package:flutter/material.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:riderapps/modules/home/locationButton.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:riderapps/modules/home/requset_view.dart';
import 'package:riderapps/modules/home/home_screen.dart';
import 'package:riderapps/modules/helper/helperMethod.dart';
import 'package:provider/provider.dart';
import 'package:riderapps/widgets/ProgressDialog.dart';
import 'package:riderapps/widgets/PredictionTile.dart';
import 'package:riderapps/widgets/BrandDivier.dart';
import 'package:riderapps/modules/dataProviders/appData.dart';
import 'package:riderapps/modules/helper/request_helper.dart';
import 'package:riderapps/modules/datamodels/prediction.dart';
import 'package:riderapps/modules/datamodels/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

late String addressCurrent;
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {
  late Position currentPosition;
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();
  var focusDestination = FocusNode();
  bool focused = false;

  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }
  List<Prediction> destinationPredictionList = [];
  void searchPlace(String placeName) async {
    if (placeName.length > 1) {
      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyCH1M_2GJ66XvaE0s5xsc7GGgEtUU2v4kQ&sessiontoken=123254251&components=country:ng';
      var response = await RequestHelper.getRequest(url);
      if (response == 'failed') {
        return;
      }
      if (response['status'] == 'OK') {
        var predictionJson = response['predictions'];
        var thisList = (predictionJson as List).map((e) =>
            Prediction.fromJson(e)).toList();
        setState(() {
          destinationPredictionList = thisList;
        });
      }
    }
  }

  void setUpGeolocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    lati = currentPosition.latitude;
    longi = currentPosition.longitude;
    addressCurrent = await helperMthod.findCoordinateAddress(position, context);
    pickupController.text = addressCurrent;
    helperMthod.getCurrentUserInfo();
  }

  @override
  void initState() {
    setUpGeolocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 210,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ]
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5,),
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)
                      ),
                      Center(
                        child: Text('Set Destination',
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'Brand-Bold'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18,),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_pin, color: Colors.blueAccent),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: TextField(
                              controller: pickupController,
                              decoration: InputDecoration(
                                  hintText: 'Pickup location',
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
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_pin, color: Colors.green),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (value) {
                                searchPlace(value);
                              },
                              focusNode: focusDestination,
                              controller: destinationController,
                              decoration: InputDecoration(
                                  hintText: 'Where to?',
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
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          (destinationPredictionList.length > 0) ?
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListView.separated(
              padding: EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return PredictionTile(
                  prediction: destinationPredictionList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  BrandDivider(),
              itemCount: destinationPredictionList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}