import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:riderapps/constance/themes.dart';
import 'package:riderapps/modules/chat/chat_Screen.dart';
import 'package:riderapps/modules/home/promoCodeView.dart';
import 'package:riderapps/constance/global.dart' as globals;
import 'package:riderapps/modules/helper/helperMethod.dart';
import 'package:riderapps/modules/helper/firehelper.dart';
import 'package:riderapps/modules/datamodels/nearbydriver.dart';
import 'package:riderapps/widgets/BrandDivier.dart';
import 'package:riderapps/widgets/TaxiButton.dart';
import 'package:riderapps/widgets/NoDriverDialog.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:riderapps/widgets/brand_colors.dart';
import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riderapps/modules/datamodels/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riderapps/modules/helper/helperMethod.dart';
import 'package:riderapps/global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';

late Position currentPosition;
class RequsetView extends StatefulWidget {
  final  onBack;
  final  createRide;
  final  reset;
  final  selectCash;
  final  selectCard;
  final tripDetails;

  const RequsetView(
      {this.onBack, this.tripDetails, this.createRide, this.reset, this.selectCash, this.selectCard});

  @override
  _RequsetViewState createState() => _RequsetViewState();
}

class _RequsetViewState extends State<RequsetView>
    with TickerProviderStateMixin {

  double searchSheetHeight = 300;
  double rideDetailsSheetHeight = 0; // (Platform.isAndroid) ? 235 : 260
  double requestingSheetHeight = 0; // (Platform.isAndroid) ? 195 : 220
  double tripSheetHeight = 0;
  late List<NearbyDriver> availableDrivers;
  String appState = 'NORMAL';
  int driverRequestTimeout = 30;
  //StreamSubscription<Event> rideSubscription;
   late StreamSubscription rideSubscription;
  String accept = 'Normal';
  var status = '';
  var driverFullName = '';
  var driverPhoneNumber = '';
  var driverCarDetails = '';
  var paymentType = 'cash';
  var tripStatusDisplay = 'Driver is Arriving';
  late DatabaseReference rideRef;
  late DatabaseReference reffed;
  // (Platform.isAndroid) ? 275 : 300
  bool isRequestingLocationDetails = false;
  void cancelRequest() {
    widget.reset();
    widget.onBack();
  }

  void  setUpGeolocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
  }

  void getCredit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
    DatabaseReference reference = FirebaseDatabase.instance.ref().child('userCredit/$phoneNumber');
    final snapshot = await reference.get();
      if (snapshot.value != null) {
        var setStated = int.parse(snapshot.value.toString());
        print(setStated);
        prefs.setInt('oldAmount', setStated);
      }
  }

  void noDriverFound(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverDialog()
    );

  }

    @override
    Widget build(BuildContext context) {
      getCredit();
      return Stack(
          children: <Widget>[
          Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height,
          child: Column(
              children: <Widget>[
          Column(
          children: <Widget>[
          Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
          left: 8,
          right: 8),
      child: Row(
      children: <Widget>[
      SizedBox(
      height: AppBar().preferredSize.height,
      width: AppBar().preferredSize.height,
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
      ),
      child: InkWell(
      onTap: () {
      widget.onBack();
      },
      child: Icon(
      Icons.arrow_back,
      color:
      Theme.of(context).textTheme.headline4!.color,
      )),
      ),
      ),
      ),
      ],
      ),
      ),
      ],
      ),
      Expanded(
      child: SizedBox(),
      ),
      !isConfrimDriver
      ? Card(
      elevation: 16,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      ),
      ),
      child: Column(
      children: <Widget>[
      Container(
      color: Theme.of(context)
          .dividerColor
          .withOpacity(0.03),
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
      children: <Widget>[
      Icon(FontAwesomeIcons.car),
      SizedBox(
      width: 16,
      ),
      Expanded(
      child: Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: <Widget>[
      Text(
      AppLocalizations.of(
      'Request a driver'),
      style: Theme.of(context)
          .textTheme
        .subtitle1,
      ),
      Text(AppLocalizations.of('Near by you'),
      style: Theme.of(context)
          .textTheme
          .caption),
      ],
      ),
      ),
      Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
      Text(
      (widget.tripDetails != null)? '${helperMthod.estimateFares(widget.tripDetails)}': '',
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
      color: Theme.of(context)
          .primaryColor,
      fontWeight: FontWeight.bold,
      ),
      ),
      // Text('${widget.tripDetails.durationValue / 60 != null ? 0 : widget.tripDetails.durationValue / 60 } min', style: Theme.of(context).textTheme.caption),
      ],
      )
      ],
      ),
      ),
      ),
      Divider(
      height: 1,
      color: Theme.of(context).disabledColor,
      ),
      Padding(
      padding: const EdgeInsets.only(
      top: 16, bottom: 16, left: 8, right: 8),
      child: Row(
      children: <Widget>[
      Expanded(
      child: InkWell(
      onTap: () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cardVerified = prefs.getString('lastDigits');
      print(cardVerified);
      var creditAmount = prefs.getInt("oldAmount");
      setState(() {
      if(cardVerified != null && creditAmount == null ){
      paymentType = 'card';
      widget.selectCard();
      } else if(creditAmount != null){
      paymentType = 'cash';
      widget.selectCash();
      FlutterToastr.show("You have an outstanding payment of $creditAmount.", context);
      // Fluttertoast.showToast(
      // msg: "You have an outstanding payment of $creditAmount.",
      // toastLength: Toast.LENGTH_SHORT,
      // gravity: ToastGravity.CENTER,
      // timeInSecForIosWeb: 15,
      // backgroundColor: Colors.red,
      // textColor: Colors.white,
      // fontSize: 20.0
      // );
      } else {
      paymentType = 'cash';
      widget.selectCash();
      FlutterToastr.show("Kindly link a card to use this option.", context);
      // Fluttertoast.showToast(
      // msg: "Kindly link a card to use this option.",
      // toastLength: Toast.LENGTH_SHORT,
      // gravity: ToastGravity.CENTER,
      // timeInSecForIosWeb: 15,
      // backgroundColor: Colors.red,
      // textColor: Colors.white,
      // fontSize: 20.0
      // );
      }
      });
      },
      child: Column(
      children: <Widget>[
      Icon(
      Icons.account_balance_wallet,
      color:
      Theme.of(context).disabledColor,
      ),
      Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
      'Select Card',
      style: Theme.of(context)
          .textTheme
          .caption
          !.copyWith(
      color: Theme.of(context)
          .disabledColor,
      ),
      ),
      ),
      ],
      ),
      ),
      ),
      Container(
      color: Theme.of(context).dividerColor,
      width: 1,
      height: 48,
      ),
      Expanded(
      child: InkWell(
      onTap: () {
      },
      child: Column(
      children: <Widget>[
      Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
      paymentType,
      style: Theme.of(context)
          .textTheme
          .caption
          !.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      color: Theme.of(context)
          .disabledColor,
      ),
      ),
      ),
      ],
      ),
      ),
      ),
      Container(
      color: Theme.of(context).dividerColor,
      width: 1,
      height: 48,
      ),
      Expanded(
      child: InkWell(
      onTap: () {
      setState(() {
      paymentType = 'cash';
      });
      widget.selectCash();
      },
      child: Column(
      children: <Widget>[
      Icon(
      Icons.money,
      color:
      Theme.of(context).disabledColor,
      ),
      Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
      'Select Cash',
      style: Theme.of(context)
          .textTheme
          .caption
          !.copyWith(
      // fontWeight: FontWeight.bold,
      color: Theme.of(context)
          .disabledColor,
      ),
      ),
      ),
      ],
      ),
      ),
      ),
      ],
      ),
      ),
      Padding(
      padding: const EdgeInsets.only(
      left: 24, right: 24, bottom: 16, top: 8),
      child: Container(
      height: 48,
      decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius:
      BorderRadius.all(Radius.circular(24.0)),
      boxShadow: <BoxShadow>[
      BoxShadow(
      color: Theme.of(context).dividerColor,
      blurRadius: 8,
      offset: Offset(4, 4),
      ),
      ],
      ),
      child: Material(
      color: Colors.transparent,
      child: InkWell(
      borderRadius:
      BorderRadius.all(Radius.circular(24.0)),
      highlightColor: Colors.transparent,
      onTap: () {
      setState(() {
      isConfrimDriver = true;
      });
      //   availableDrivers = FireHelper.nearbyDriverList;
      widget.createRide();
      // showRequestingSheet();
      },
      child: Center(
      child: Text(
      AppLocalizations.of('Request'),
      style: Theme.of(context)
          .textTheme
          .subtitle1
          !.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold),
      ),
      ),
      ),
      ),
      ),
      ),
      SizedBox(
      height: MediaQuery.of(context).padding.bottom,
      )
      ],
      ),
      )
          : confirmDriverBox(context),
      ],
      ),
      ),
      ],
      );
  }

  bool isConfrimDriver = false;
  Widget searchDriver(context) {
    /// Request Sheet
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Stack(
        alignment: Alignment.bottomCenter,
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
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
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
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'here kjgjkj',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        BrandDivider(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Color',
                          style: TextStyle(color: BrandColors.colorTextLight),
                        ),
                        Text(
                          'Abas',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        BrandDivider(),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular((25))),
                                    border: Border.all(
                                        width: 1.0,
                                        color: BrandColors.colorTextLight),
                                  ),
                                  child: Icon(Icons.call),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Call'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular((25))),
                                    border: Border.all(
                                        width: 1.0,
                                        color: BrandColors.colorTextLight),
                                  ),
                                  child: Icon(Icons.list),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Details'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular((25))),
                                    border: Border.all(
                                        width: 1.0,
                                        color: BrandColors.colorTextLight),
                                  ),
                                  child: Icon(Icons.clear),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Cancel'),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget confirmDriverBox(context) {
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 16,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    new BoxShadow(
                      color: globals.isLight
                          ? Colors.black.withOpacity(0.2)
                          : Colors.white.withOpacity(0.2),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 0,
            left: 0,
            bottom: 16,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 12),
              child: Container(
                // height: 256,
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    new BoxShadow(
                      color: globals.isLight
                          ? Colors.black.withOpacity(0.2)
                          : Colors.white.withOpacity(0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
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
                height: 200.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextLiquidFill(
                          text: 'Requesting a Ride...',
                          waveColor: BrandColors.colorTextSemiLight,
                          boxBackgroundColor: Colors.white,
                          textStyle: TextStyle(
                              color: BrandColors.colorText,
                              fontSize: 22.0,
                              fontFamily: 'Brand-Bold'),
                          boxHeight: 40.0,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          cancelRequest();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                width: 1.0,
                                color: BrandColors.colorLightGrayFair),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Cancel ride',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  bool isConfirm = false;

}
