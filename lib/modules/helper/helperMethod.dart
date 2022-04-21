import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:riderapps/modules/helper/request_helper.dart';
import 'package:riderapps/modules/datamodels/address.dart';
import 'package:riderapps/global.dart';
import 'package:provider/provider.dart';
import 'package:riderapps/modules/dataProviders/appData.dart';
import 'package:riderapps/modules/datamodels/directiondetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riderapps/modules/datamodels/user.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';










class helperMthod {
  static getData() {
    final User? user = FirebaseAuth.instance.currentUser;
    String? userid = user?.uid;
    return FirebaseDatabase.instance.reference().child('user/$userid');
  }

   static getCurrentUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentFirebaseUser = FirebaseAuth.instance.currentUser!;
    String userid = currentFirebaseUser.uid;
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child(
        'user/$userid');
    final snapshot = await userRef.get();

      if (snapshot.value != null) {
        currentUserInfo = UserP.fromSnapshot(snapshot);
        print(currentUserInfo);
        prefs.setString('fullName', currentUserInfo.fullName);
        prefs.setString('email', currentUserInfo.email);
        prefs.setString('phone', currentUserInfo.phone);
        prefs.setString('id', userid);
      }
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);
    return randInt.toDouble();
  }

  static Future<String>findCoordinateAddress (Position position,context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String placeAddress = '';
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position
        .latitude}, ${position
        .longitude}&key=AIzaSyCH1M_2GJ66XvaE0s5xsc7GGgEtUU2v4kQ';
    var response = await RequestHelper.getRequest(url);
    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];
      Address pickupAddress = new Address();
      pickupAddress.latitude = position.latitude;
      pickupAddress.longitude = position.longitude;
      pickupAddress.placeName = placeAddress;
      await prefs.setString('pPlaceName', placeAddress);
      await prefs.setDouble('pLatitude', position.latitude);
      await prefs.setDouble('pLongitude', position.longitude);
      Future.delayed(const Duration(milliseconds: 5000), () {
        Provider.of<AppData>(context, listen: false).updatePickupAddress(
            pickupAddress);
      });
    }
    return placeAddress;
  }

  static Future<DirectionDetails?> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition
        .latitude},${startPosition.longitude}&destination=${endPosition
        .latitude},${endPosition
        .longitude}&mode=driving&key=AIzaSyCH1M_2GJ66XvaE0s5xsc7GGgEtUU2v4kQ';
    var response = await RequestHelper.getRequest(url);
    if (response == 'failed') {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText =
    response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
    response['routes'][0]['legs'][0]['duration']['value'];
    directionDetails.distanceText =
    response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
    response['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.encodedPoints =
    response['routes'][0]['overview_polyline']['points'];
    return directionDetails;
  }

  static int estimateFares (DirectionDetails details) {
    // per km = $0.3, 5 naira
    // per minute = $0.2,  3 naira
    // base fare = $3, 400 naira
    double baseFare = 400;
    double distanceFare = (details.distanceValue / 1000) * 50;
    double timeFare = (details.durationValue / 60) * 30;
    double totalFare = baseFare + distanceFare + timeFare;
    return totalFare.truncate();
  }

  static sendNotification(String token, context, String ride_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var destinationPlace = prefs.getString('dplaceName');
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };
    Map notificationMap = {
      'title': 'NEW TRIP REQUEST',
      'body': 'You have a new trip request, Click to accept.'
    };
    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id': ride_id,
    };
    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    var response = await http.post(
        url,
        headers: headerMap,
        body: jsonEncode(bodyMap)
    );
    print(response.body);
  }


}

