import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:riderapps/constance/global.dart' as globals;
import 'package:riderapps/modules/datamodels/directiondetails.dart';
import 'package:riderapps/modules/datamodels/nearbydriver.dart';
import 'package:riderapps/modules/drawer/drawer.dart';
import 'package:riderapps/modules/helper/firehelper.dart';
import 'package:riderapps/modules/helper/chargeHelper.dart';
import 'package:riderapps/modules/home/addressSelctionView.dart';
import 'package:riderapps/modules/home/requset_view.dart';
import 'package:riderapps/modules/home/acceptSheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riderapps/modules/helper/helperMethod.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riderapps/widgets/CollectPaymentDialog.dart';

import 'class/homeclass.dart';

late double lati;
late double longi;
late String addressCurrent;

class HomeScreen extends StatefulWidget {
  final double lat;
  final double long;

  HomeScreen(this.lat, this.long);

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late Position currentPosition;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _Markers = {};
  Set<Circle> _Circles = {};
  double searchSheetHeight = 300;
  double rideDetailsSheetHeight = 0; // (Platform.isAndroid) ? 235 : 260
  double requestingSheetHeight = 0; // (Platform.isAndroid) ? 195 : 220
  double tripSheetHeight = 0; // (Platform.isAndroid) ? 275 : 300
 late AnimationController animationController;
  late List<NearbyDriver> availableDrivers;
  late DirectionDetails tripDirectionDetails;
  late BitmapDescriptor nearbyIcon;
  String appState = 'NORMAL';
  int driverRequestTimeout = 30;
    StreamSubscription? rideSubscription;
  String accept = 'Normal';
  var status = '';
  var drib;
  var driverFullName = '';
  var driverPhoneNumber = '';
  var driverCarDetails = '';
  var driverCarNumber = '';
  var photoUrl = '';
  var paymentType = 'cash';
  var tripStatusDisplay = 'Driver is Arriving';
  late DatabaseReference ?rideRef;
  late  DatabaseReference rideHistoryRef;
  late DatabaseReference rideCredit;
  late DatabaseReference reffed;
  var driverSaved;
  // (Platform.isAndroid) ? 275 : 300
  bool isRequestingLocationDetails = false;
  bool requestAccepted = false;
  bool nearbyDriversKeysLoaded = false;
  var phoneNumber;

  void setUpGeolocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    lati = currentPosition.latitude;
    longi = currentPosition.longitude;
    addressCurrent = await helperMthod.findCoordinateAddress(position, context);
    startGeofireListener();
  }

  void setInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    helperMthod.getData().then((val) {
      print(val.email);
      prefs.setString('fullName', val.fullname);
      prefs.setString('email', val.email);
      prefs.setString('phone', val.phone);
      // prefs.setString('id', userid);
    });
  }

  void getCredit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
    DatabaseReference riderCRef = FirebaseDatabase.instance.ref().child(
        'userCredit/$phoneNumber');
    final snapshot = await riderCRef.get();

     Map valuesnapshot = snapshot.value as Map;
      if (snapshot.value != null) {
        var setStated = int.parse(valuesnapshot.toString());
        print(setStated);
        prefs.setInt('oldAmount', setStated);
      }
  }

  void setCardInfo() async {
    var UserId = FirebaseAuth.instance.currentUser?.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DatabaseReference cardRef = FirebaseDatabase.instance.ref().child(
        'userCardDetails/$UserId');
    final snapshot = await cardRef.get();
      if (snapshot.value != null) {
        Map values = snapshot.value as Map;
        values.forEach((key,values) {
          prefs.setString('auth', values["auth"]);
          prefs.setString('card_type', values["card_type"]);
          prefs.setString('lastDigits', values["lastDigits"]);
        });
      }
  }

  late GoogleMapController _mapController;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSerchMode = false;
  bool isUp = true;
  late  BitmapDescriptor carMapBitmapDescriptor;
  late  BitmapDescriptor startMapBitmapDescriptor;
  late  BitmapDescriptor endMapBitmapDescriptor;
  late  BuildContext currentcontext;
  TextEditingController serachController = TextEditingController();
  ProsseType prosseType = ProsseType.dropOff;
  int carOneIndex = 0,
      carTwoIndex = 0,
      carThreeIndex = 0,
      carFourIndex = 0,
      carFiveIndex = 0;
  List<LatLng> carPointOne = [],
      carPointTwo = [],
      carPointThree = [],
      carPointFour = [],
      carPointFive = [],

      poliList = [];  void setMakerPinSize(BuildContext context) async {
    if (currentcontext == null) {
      currentcontext = context;
      final ImageConfiguration imagesStartConfiguration =
      createLocalImageConfiguration(currentcontext);
      carMapBitmapDescriptor = await BitmapDescriptor.fromAssetImage(
          imagesStartConfiguration, ConstanceData.mapCar);
      final ImageConfiguration startStartConfiguration =
      createLocalImageConfiguration(currentcontext);
      startMapBitmapDescriptor = await BitmapDescriptor.fromAssetImage(
          startStartConfiguration, ConstanceData.startmapPin);
      final ImageConfiguration endStartConfiguration =
      createLocalImageConfiguration(currentcontext);
      endMapBitmapDescriptor = await BitmapDescriptor.fromAssetImage(
          endStartConfiguration, ConstanceData.endmapPin);
    }
  }
  final _random = new math.Random();
  int next(int min, int max) => min + _random.nextInt(max - min);
  void createMarker() {
    if (nearbyIcon == null) {
      ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration,
          (Platform.isIOS) ? ConstanceData.mapCar : ConstanceData.mapCar)
          .then((icon) {
        nearbyIcon = icon;
      });
    }
  }

  @override
  void initState() {
    getCredit();
    setCardInfo();
    setUpGeolocation();
    serachController.text = AppLocalizations.of('Enter Destination Address');
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 480));
    animationController..animateTo(1);
    super.initState();
    helperMthod.getCurrentUserInfo();
    _carPinInitState();
  }

  void _carPinInitState() {
    carPointOne = ConstanceData.getCarOnePolyLineList();
    carPointTwo = ConstanceData.getCarTwoPolyLineList();
    carPointThree = ConstanceData.getCarThreePolyLineList();
    carPointFour = ConstanceData.getCarFourPolyLineList();
    // carPointFive = ConstanceData.getCarFivePolyLineList();
    poliList = ConstanceData.getRoutePolyLineList();
    Timer(Duration(milliseconds: next(1200, 4000)), carOnePin);
    Timer(Duration(milliseconds: next(1200, 4000)), carTwoPin);
    Timer(Duration(milliseconds: next(1200, 4000)), carThreePin);
    Timer(Duration(milliseconds: next(1200, 4000)), carFourPin);
    // Timer(Duration(milliseconds: next(1200, 4000)), carFivePin);
  }

  Future carOnePin() async {
    if (carOneIndex + 1 < carPointOne.length) {
      carOneIndex += 1;
    } else {
      carOneIndex = 0;
    }
    if (mounted) setState(() {});
    Timer(Duration(milliseconds: next(1200, 4000)), carOnePin);
  }

  Future carTwoPin() async {
    if (carTwoIndex + 1 < carPointTwo.length) {
      carTwoIndex += 1;
    } else {
      carTwoIndex = 0;
    }
    if (mounted) setState(() {});
    Timer(Duration(milliseconds: next(1200, 4000)), carTwoPin);
  }

  Future carThreePin() async {
    if (carThreeIndex + 1 < carPointThree.length) {
      carThreeIndex += 1;
    } else {
      carThreeIndex = 0;
    }
    if (mounted) setState(() {});
    Timer(Duration(milliseconds: next(1200, 4000)), carThreePin);
  }

  Future carFourPin() async {
    if (carFourIndex + 1 < carPointFour.length) {
      carFourIndex += 1;
    } else {
      carFourIndex = 0;
    }
    if (mounted) setState(() {});
    Timer(Duration(milliseconds: next(1200, 4000)), carFourPin);
  }

  Future carFivePin() async {
    if (carFiveIndex + 1 < carPointFive.length) {
      carFiveIndex += 1;
    } else {
      carFiveIndex = 0;
    }
    if (mounted) setState(() {});
    Timer(Duration(milliseconds: next(1200, 4000)), carFivePin);
  }

  Map<MarkerId, Marker> getMarkerList(BuildContext context) {
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    if (carMapBitmapDescriptor != null) {
      for (var i = 0; i < 4; i++) {
        LatLng startPoint = i == 0
            ? carPointOne[carOneIndex]
            : i == 1
            ? carPointTwo[carTwoIndex]
            : i == 2
            ? carPointThree[carThreeIndex]
            : carPointFour[carFourIndex];
        LatLng lastPoint = i == 0
            ? carPointOne[carOneIndex - 1 == -1
            ? carPointOne.length - 1
            : carOneIndex - 1]
            : i == 1
            ? carPointTwo[carTwoIndex - 1 == -1
            ? carPointTwo.length - 1
            : carTwoIndex - 1]
            : i == 2
            ? carPointThree[carThreeIndex - 1 == -1
            ? carPointThree.length - 1
            : carThreeIndex - 1]
            : carPointFour[carFourIndex - 1 == -1
            ? carPointFour.length - 1
            : carFourIndex - 1];
        final MarkerId markerId2 = MarkerId('$i');
        final Marker marker2 = Marker(
            markerId: markerId2,
            position: startPoint,
            anchor: Offset(0.5, 0.5),
            icon: carMapBitmapDescriptor,
            rotation: ConstanceData.getCarAngle(startPoint, lastPoint));
        markers.addAll({markerId2: marker2});
      }
    }
    if (startMapBitmapDescriptor != null &&
        endMapBitmapDescriptor != null &&
        prosseType == ProsseType.requset) {
      final MarkerId markerId2 = MarkerId('start');
      final Marker marker2 = Marker(
        markerId: markerId2,
        position: poliList.first,
        anchor: Offset(0.5, 0.5),
        icon: startMapBitmapDescriptor,
      );
      markers.addAll({markerId2: marker2});
      final MarkerId markerId = MarkerId('end');
      final Marker marker = Marker(
        markerId: markerId,
        position: poliList.last,
        anchor: Offset(0.5, 1.0),
        icon: endMapBitmapDescriptor,
      );
      markers.addAll({markerId: marker});
    }
    return markers;
  }


  Future<void> getDirection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//pPlaceName
    var pickupLat = prefs.getDouble('pLatitude');
    var pickupLong = prefs.getDouble('pLongitude');
    var pPlaceName = prefs.getString('pPlaceName');
    var dplaceName = prefs.getString('dplaceName');
    var destinationLongitude = prefs.getDouble('dLongitude');
    var destinationLatitude = prefs.getDouble('dLatitude');
    var pickLatLng = LatLng(pickupLat!, pickupLong!);
    var destinationLatLng = LatLng(destinationLatitude!, destinationLongitude!);
    var thisDetails =
    await helperMthod.getDirectionDetails(pickLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetails = thisDetails!;
    });
    print('I got here thank you very much');
    print(thisDetails?.encodedPoints);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
    polylinePoints.decodePolyline(thisDetails?.encodedPoints);
    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });
    LatLngBounds bounds;
    if (pickLatLng.latitude > destinationLatLng.latitude &&
        pickLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude));
    } else if (pickLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
        northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pPlaceName, snippet: 'My Location'),
    );
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: dplaceName, snippet: 'Destination'),
    );
    setState(() {
      _Markers.add(pickupMarker);
      _Markers.add(destinationMarker);
    });
    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: Colors.green,
    );
    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.deepPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: Colors.deepPurple,
    );
    setState(() {
      _Circles.add(pickupCircle);
      _Circles.add(destinationCircle);
    });
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    createMarker();
    setMakerPinSize(context);
    _carPinInitState();
    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400
            ? MediaQuery.of(context).size.width * 0.72
            : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Home',
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              markers: _Markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(lati == null ? widget.lat : lati,
                    longi == null ? widget.long : longi),
                tilt: 30.0,
                zoom: 14,
              ),
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) async {
                _mapController = controller;
                setMapStyle();
              },
            ),
          ),
          prosseType != ProsseType.mapPin && prosseType != ProsseType.requset
              ? _getAppBarUI()
              : SizedBox(),
          prosseType == ProsseType.dropOff
              ? AddressSelctionView(
            animationController: animationController,
            isSerchMode: isSerchMode,
            isUp: isUp,
            mapCallBack: () {
              animationController
                  .animateTo(1, duration: Duration(milliseconds: 480))
                  .then((f) {
                setState(() {
                  prosseType = ProsseType.mapPin;
                });
              });
            },
            serachController: serachController,
            gpsClick: () {
              if (_mapController != null) {
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(lati == null ? widget.lat : lati,
                          longi == null ? widget.long : longi),
                      zoom: 16.0,
                      tilt: 24.0,
                    ),
                  ),
                );
              }
            },
            getDirection: () {
              getDirection();
              setState(() {
                prosseType = ProsseType.requset;
              });
            },
          )
              : !requestAccepted
              ? RequsetView(
            onBack: () {
              setState(() {
                prosseType = ProsseType.dropOff;
                _polylines.clear();
              });
            },
            selectCash: () {
              setState(() {
                paymentType = 'cash';
                print(paymentType);
              });
            },
            selectCard: () {
              setState(() {
                paymentType = 'card';
                print(paymentType);
              });
            },
            tripDetails: tripDirectionDetails,
            createRide: () async {
              getCredit();
              var UserId = FirebaseAuth.instance.currentUser!.uid;
              availableDrivers = FireHelper.nearbyDriverList;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var pickupLat = prefs.getDouble('pLatitude');
              var pickupLong = prefs.getDouble('pLongitude');
              var pPlaceName = prefs.getString('pPlaceName');
              var dplaceName = prefs.getString('dplaceName');
              var fullname = prefs.getString('fullName');
              var email = prefs.getString('email');
              var phone = prefs.getString('phone');
              var id = prefs.getString('id');
              var destinationLongitude =
              prefs.getDouble('dLongitude');
              var destinationLatitude = prefs.getDouble('dLatitude');
              rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();
              rideHistoryRef = FirebaseDatabase.instance.reference() .child('rideRequestHistory/$UserId').push();
              Map pickupMap = {
                'latitude': pickupLat.toString(),
                'longitude': pickupLong.toString(),
              };
              Map destinationMap = {
                'latitude': destinationLatitude.toString(),
                'longitude': destinationLongitude.toString(),
              };
              DateTime createdAT = DateTime.now();
              String convertedDateTime = "${createdAT.year.toString()}-${createdAT.month.toString().padLeft(2,'0')}-${createdAT.day.toString().padLeft(2,'0')}: ${createdAT.hour.toString()}:${createdAT.minute.toString()}min";
              Map rideMap = {
                'created_at': convertedDateTime,
                'rider_name': fullname,
                'rider_phone': phone,
                'pickup_address': pPlaceName,
                'destination_address': dplaceName,
                'location': pickupMap,
                'amount': '0',
                'destination': destinationMap,
                'payment_method': paymentType,
                'email': email,
                'driver_id': 'waiting',
              };
              rideRef?.set(rideMap);
              rideHistoryRef.set(rideMap);
              if (availableDrivers.length == 0) {
                cancelRequest();
                // widget.reset();
                // noDriverFound();
                rideHistoryRef.child('status').set('timeout');
                rideRef?.remove();
                return;
              }
              setState(() {});
              var driver = availableDrivers[0];
              setState(() {
                drib = driver;
              });
              availableDrivers.removeAt(0);
              print(driver.key);
              driverSaved = driver;
              DatabaseReference driverTripRef = FirebaseDatabase.instance.ref().child('drivers/${driver.key}/newtrip');
              driverTripRef.set(rideRef?.key);
              // Get and notify driver using token
              DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child('drivers/${driver.key}/token');
              final snapshot = await tokenRef.get();

                if (snapshot.value != null) {
                  String token = snapshot.value.toString();
                  // send notification to selected driver
                  helperMthod.sendNotification(token, context, "rideRef.key.toString()");
                } else {
                  return;
                }
                const oneSecTick = Duration(seconds: 1);
                var timer = Timer.periodic(oneSecTick, (timer) {
                  setState(() {
                    appState = 'REQUESTING';
                  });
                  // stop timer when ride request is cancelled;
                  if (appState != 'REQUESTING') {
                    driverTripRef.set('cancelled');
                    driverTripRef.onDisconnect();
                    timer.cancel();
                    driverRequestTimeout = 30;
                    rideHistoryRef.child('status').set('cancelled');
                    rideRef?.remove();
                  }
                  driverRequestTimeout--;
                  // a value event listener for driver accepting trip request
                  driverTripRef.onValue.listen((event) {
                    // confirms that driver has clicked accepted for the new trip request
                    if (event.snapshot.value.toString() == 'accepted') {
                      driverTripRef.onDisconnect();
                      timer.cancel();
                      driverRequestTimeout = 30;
                      rideHistoryRef.child('status').set('confirmed');
                    }
                  });
                  if (driverRequestTimeout == 0) {
                    //informs driver that ride has timed out
                    driverTripRef.set('timeout');
                    driverTripRef.onDisconnect();
                    driverRequestTimeout = 30;
                    timer.cancel();
                    //select the next closest driver
                    print('timed out');
                    rideHistoryRef.child('status').set('timeout');
                    rideRef?.remove();
                  }
                });
              rideSubscription =
                  rideRef?.onValue.listen((event) async {
                    Map valsnapshot = event.snapshot.value as Map;
                    //check for null snapshot
                    if (event.snapshot.value == null) {
                      return;
                    }
                    //get car details
                    if (valsnapshot['car_details'] != null) {
                      setState(() {
                        driverCarDetails = valsnapshot['car_details']
                            .toString();
                      });
                    }
                    // get driver name
                    if (valsnapshot['driver_name'] != null) {
                      setState(() {
                        driverFullName = valsnapshot['driver_name']
                            .toString();
                        print(valsnapshot['driver_name']);
                      });
                    }
                    if (valsnapshot['platNumber'] != null) {
                      setState(() {
                        driverCarNumber = valsnapshot['platNumber']
                            .toString();
                        print(valsnapshot['platNumber']);
                      });
                    }
                    // get driver phone number driverCarNumber
                    if (valsnapshot['driver_phone'] != null) {
                      setState(() {
                        driverPhoneNumber = valsnapshot['driver_phone']
                            .toString();
                      });
                    }
                    if (valsnapshot['photo_url'] != null) {
                      setState(() {
                        photoUrl =
                            valsnapshot['photo_url'].toString();
                      });
                    }
                    if (valsnapshot['status'] != null) {
                      setState(() {
                        status = valsnapshot['status'].toString();
                      });
                    }
                    //get and use driver location updates
                    if (valsnapshot['driver_location'] != null) {
                      double driverLat = double.parse(valsnapshot['driver_location']['latitude']
                          .toString());
                      double driverLng = double.parse(valsnapshot['driver_location']['longitude']
                          .toString());
                      LatLng driverLocation =
                      LatLng(driverLat, driverLng);
                      if(status == 'accepted'){
                        updateToPickup(driverLocation);
                      }
                      //arrived
                      else if(valsnapshot['status'] == 'arrived'){
                        setState(() {
                          tripStatusDisplay = 'Driver has arrived';
                        });
                      } else if(valsnapshot['status'] == 'ontrip'){
                        updateToDestination(driverLocation);
                      }
                    }
                    if (status == 'accepted') {
                      // showTripSheet();
                      setState(() {
                        requestAccepted = true;
                      });
                      Geofire.stopListener();
                      removeGeofireMarkers();
                    }
//amount
                    if (status == 'ended') {
                     Map valsnapshot = event.snapshot.value as Map;
                      if (valsnapshot['fares'] != null) {
                        int fares = int.parse( valsnapshot['fares'].toString());
                        var amountCompleted = valsnapshot['fares'].toString();
                        var methodGotten = valsnapshot['payment_method'];
                        if (methodGotten == 'card') {
                          var chargeResult = ChargeHelper.chargeAmount(fares);
                          print(chargeResult);
                          if (chargeResult == 200) {
                            rideHistoryRef.child('status').set('completed');
                            rideHistoryRef.child('amount').set(amountCompleted);
                            var response = await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) =>
                                  CollectPayment(
                                    paymentMethod: 'card',
                                    fares: fares,
                                  ),
                            );
                            if (response == 'close') {
                              rideRef?.onDisconnect();
                              rideHistoryRef.onDisconnect();
                              rideRef = null;
                              rideSubscription?.cancel();
                              rideSubscription = null;
                              setState(() {
                                prosseType = ProsseType.dropOff;
                                _polylines.clear();
                                requestAccepted = false;
                              });
                              //   resetApp();
                            }
                          } else {
                            print(chargeResult);
                            rideCredit = FirebaseDatabase.instance.reference().child('userCredit/$phoneNumber');
                            var valued = fares.toString();
                            rideCredit.set(valued);
                            rideHistoryRef.child('status').set('completed');
                            rideHistoryRef.child('amount').set(amountCompleted);
                            var response = await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) =>
                                  CollectPayment(
                                    paymentMethod: 'card',
                                    fares: fares,
                                  ),
                            );
                            if (response == 'close') {
                              rideRef?.onDisconnect();
                              rideHistoryRef.onDisconnect();
                              rideRef = null;
                              rideSubscription?.cancel();
                              rideSubscription = null;
                              setState(() {
                                prosseType = ProsseType.dropOff;
                                _polylines.clear();
                                requestAccepted = false;
                              });
                              //   resetApp();
                            }
                          }
                        } else {
                          rideHistoryRef.child('status').set('completed');
                          rideHistoryRef.child('amount').set(amountCompleted);
                          rideCredit = FirebaseDatabase.instance.reference().child('userCredit/$phoneNumber');
                          rideCredit.remove();
                          prefs.remove("oldAmount");
                          var response = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) =>
                                CollectPayment(
                                  paymentMethod: 'cash',
                                  fares: fares,
                                ),
                          );
                          if (response == 'close') {
                            rideRef?.onDisconnect();
                            rideHistoryRef.onDisconnect();
                            rideRef = null;
                            rideSubscription?.cancel();
                            rideSubscription = null;
                            setState(() {
                              prosseType = ProsseType.dropOff;
                              _polylines.clear();
                              requestAccepted = false;
                            });
                            //   resetApp();
                          }
                        }
                      }
                      //chargeAmount
                    }
                  });
            },
            reset: () {
              setState(() {
                polylineCoordinates.clear();
                _polylines.clear();
                _Markers.clear();
                _Circles.clear();
                rideDetailsSheetHeight = 0;
                requestingSheetHeight = 0;
                tripSheetHeight = 0;
                status = '';
                driverFullName = '';
                driverPhoneNumber = '';
                driverCarNumber = '';
                driverCarDetails = '';
                tripStatusDisplay = 'Driver is Arriving';
              });
              setUpGeolocation();
            },
          )
              : AcceptView(
            carDetails: driverCarDetails,
            driverFullName: driverFullName,
            driverPhoneNumber: driverPhoneNumber,
            tripStatusDisplay: tripStatusDisplay,
            photoUrl: photoUrl,
            driverCarNumber: driverCarNumber,
            endRide: () {
              if(status == 'ontrip'){
                rideRef?.child('status').set('ended');
              } else {
                setState(() {
                  polylineCoordinates.clear();
                  _polylines.clear();
                  _Markers.clear();
                  _Circles.clear();
                  rideDetailsSheetHeight = 0;
                  requestingSheetHeight = 0;
                  tripSheetHeight = 0;
                  status = '';
                  driverFullName = '';
                  driverPhoneNumber = '';
                  driverCarNumber = '';
                  driverCarDetails = '';
                  tripStatusDisplay = 'Driver is Arriving';
                });
                setUpGeolocation();
                rideRef?.onDisconnect();
                rideRef?.remove();
                rideHistoryRef.onDisconnect();
                rideRef = null;
                rideSubscription?.cancel();
                rideSubscription = null;
                setState(() {
                  prosseType = ProsseType.dropOff;
                  _polylines.clear();
                  requestAccepted = false;
                });
                setState(() {
                  prosseType = ProsseType.dropOff;
                  _polylines.clear();
                });
              }
            },
          )
        ],
      ),
    );
  }

  Widget _getAppBarUI() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 8, right: 8),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: AppBar().preferredSize.height,
                width: AppBar().preferredSize.height,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Container(
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.all(2),
                      child: InkWell(
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: Icon(Icons.menu),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  void startGeofireListener() {
    Geofire.initialize('driversAvailable');
    Geofire.queryAtLocation(
        currentPosition.latitude, currentPosition.longitude, 20)
        ?.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];
        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];
            FireHelper.nearbyDriverList.add(nearbyDriver);
            if (nearbyDriversKeysLoaded) {
              updateDriversOnMap();
            }
            break;
          case Geofire.onKeyExited:
            FireHelper.removeFromList(map['key']);
            updateDriversOnMap();
            break;
          case Geofire.onKeyMoved:
          // Update your key's location
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];
            FireHelper.updateNearbyLocation(nearbyDriver);
            updateDriversOnMap();
            break;
          case Geofire.onGeoQueryReady:
            nearbyDriversKeysLoaded = true;
            updateDriversOnMap();
            break;
        }
      }
    });
  }

  void updateDriversOnMap() {
    setState(() {
      _Markers.clear();
    });
    Set<Marker> tempMarkers = Set<Marker>();
    for (NearbyDriver driver in FireHelper.nearbyDriverList) {
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon: nearbyIcon,
        rotation: helperMthod.generateRandomNumber(360),
      );
      tempMarkers.add(thisMarker);
    }
    setState(() {
      _Markers = tempMarkers;
    });
  }

  void setMapStyle() async {
    if (_mapController != null) {
      if (globals.isLight)
        _mapController.setMapStyle(await DefaultAssetBundle.of(context)
            .loadString("assets/jsonFile/light_mapstyle.json"));
      else
        _mapController.setMapStyle(await DefaultAssetBundle.of(context)
            .loadString("assets/jsonFile/dark_mapstyle.json"));
    }
  }
  void setMapStylde() async {
    getDirection();
  }
  void updateToPickup(LatLng driverLocation) async {
    if (!isRequestingLocationDetails) {
      isRequestingLocationDetails = true;
      var positionLatLng =
      LatLng(currentPosition.latitude, currentPosition.longitude);
      var thisDetails =
      await helperMthod.getDirectionDetails(driverLocation, positionLatLng);
      if (thisDetails == null) {
        return;
      }
      setState(() {
        tripStatusDisplay = 'Driver is Arriving - ${thisDetails.durationText}';
      });
      isRequestingLocationDetails = false;
    }
  }

  void updateToDestination(LatLng driverLocation) async {
    if (!isRequestingLocationDetails) {
      isRequestingLocationDetails = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var destinationLongitude = prefs.getDouble('dLongitude');
      var destinationLatitude = prefs.getDouble('dLatitude');
      var dplaceName = prefs.getString('dplaceName');
      var destination = dplaceName;
      var destinationLatLng = LatLng(destinationLatitude!, destinationLongitude!);
      var thisDetails = await helperMthod.getDirectionDetails(
          driverLocation, destinationLatLng);
      if (thisDetails == null) {
        return;
      }
      setState(() {
        tripStatusDisplay =
        'Driving to Destination - ${thisDetails.durationText}';
      });
      isRequestingLocationDetails = false;
    }
  }

  void removeGeofireMarkers() {
    setState(() {
      _Markers.removeWhere((m) => m.markerId.value.contains('driver'));
    });
  }
  void cancelRequest() {
    rideRef?.remove();
    setState(() {
      appState = 'NORMAL';
    });
  }

}