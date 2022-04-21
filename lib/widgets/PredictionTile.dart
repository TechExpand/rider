import 'package:riderapps/widgets/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:riderapps/modules/dataProviders/appData.dart';
import 'package:riderapps/modules/datamodels/prediction.dart';
import 'package:riderapps/modules/helper/helperMethod.dart';
import 'package:riderapps/widgets/ProgressDialog.dart';
import 'package:riderapps/modules/dataProviders/appData.dart';
import 'package:riderapps/modules/helper/request_helper.dart';
import 'package:riderapps/modules/datamodels/prediction.dart';
import 'package:riderapps/modules/datamodels/address.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class PredictionTile extends StatelessWidget {
  final  prediction;

  PredictionTile({this.prediction});

  void getPlaceDetails(String placeID, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Please wait...',)
    );
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
      Provider.of<AppData>(context, listen: false).updateDestinationAddress(
          thisPlace);
      print(thisPlace.placeName);
      Navigator.pop(context, 'getDirection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceDetails(prediction.placeId, context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 8,),
            Row(
              children: <Widget>[
                Icon(Icons.location_on, color: Colors.deepOrange),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        prediction.mainText, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, color: Colors.black),),
                      SizedBox(height: 2,),
                      Text(prediction.secondaryText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: BrandColors.colorDimText),),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}