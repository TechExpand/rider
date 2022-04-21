import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:riderapps/constance/global.dart' as globals;
import 'package:riderapps/constance/themes.dart';
import 'package:riderapps/extension/string_extension.dart';
import 'package:riderapps/modules/auth/phone_verification.dart';
import 'package:riderapps/modules/auth/verify_login.dart';
import 'package:connectivity/connectivity.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riderapps/modules/home/home_screen.dart';

late String fullname;
late String email;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();

}

  class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  var fullnameController = new TextEditingController();
  var emailController = new TextEditingController();
  Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('US');
  bool isSignUp = true;
  String phoneNumber = '';
  // ignore: missing_return
  registerUser () async {
    print("+${_selectedCountry.phoneCode}" + phoneNumber);
  }
   late Position currentPosition;

  void  setUpGeolocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
  }
  @override
  void initState() {
    setUpGeolocation();
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationController..forward();
  }

  @override
  Widget build(BuildContext context) {
    globals.locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery
            .of(context)
            .size
            .height, minWidth: MediaQuery
            .of(context)
            .size
            .width),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ClipRect(
                        child: Container(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          child: AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget ?child) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                        0.0,
                                        160 *
                                            (1.0 -
                                                (AlwaysStoppedAnimation(
                                                    Tween(begin: 0.4, end: 1.0)
                                                        .animate(
                                                        CurvedAnimation(
                                                            parent: animationController,
                                                            curve: Curves
                                                                .fastOutSlowIn)))
                                                    .value)
                                                    .value) -
                                            16,
                                        0.0),
                                    child: Image.asset(
                                      ConstanceData.buildingImageBack,
                                      color: HexColor("#FFFFFF"),
                                    ),
                                  ),
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                        0.0,
                                        160 *
                                            (1.0 -
                                                (AlwaysStoppedAnimation(
                                                    Tween(begin: 0.8, end: 1.0)
                                                        .animate(
                                                        CurvedAnimation(
                                                            parent: animationController,
                                                            curve: Curves
                                                                .fastOutSlowIn)))
                                                    .value)
                                                    .value),
                                        0.0),
                                    child: Image.asset(
                                      ConstanceData.buildingImage,
                                      color: HexColor("#FFFFFF"),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: (MediaQuery
                                        .of(context)
                                        .size
                                        .height / 8),
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: AnimatedBuilder(
                                          animation: animationController,
                                          builder: (BuildContext context,
                                              Widget ?child) {
                                            return Transform(
                                              transform: new Matrix4
                                                  .translationValues(
                                                  0.0,
                                                  80 *
                                                      (1.0 -
                                                          (AlwaysStoppedAnimation(
                                                            Tween(begin: 0.0,
                                                                end: 1.0)
                                                                .animate(
                                                              CurvedAnimation(
                                                                parent: animationController,
                                                                curve: Curves
                                                                    .fastOutSlowIn,
                                                              ),
                                                            ),
                                                          ).value)
                                                              .value),
                                                  0.0),
                                              child: Image.asset(
                                                ConstanceData.appIcon,
                                                height: 350.0,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(0.0),
              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: (MediaQuery
                          .of(context)
                          .size
                          .height / 2) - (MediaQuery
                          .of(context)
                          .size
                          .height < 600 ? 124 : 86),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: 8,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    splashColor: Theme
                                        .of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                    onTap: () {
                                      setState(() {
                                        isSignUp = true;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              AppLocalizations.of('Sign Up'),
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .headline3
                                                  !.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: isSignUp ? Theme
                                                    .of(context)
                                                    .textTheme
                                                    .headline3
                                                    !.color : Theme
                                                    .of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                          ),
                                          isSignUp
                                              ? Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Card(
                                              elevation: 0,
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              child: SizedBox(
                                                height: 6,
                                                width: 48,
                                              ),
                                            ),
                                          )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    splashColor: Theme
                                        .of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                    onTap: () {
                                      setState(() {
                                        isSignUp = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              AppLocalizations.of('Sign In'),
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .headline3
                                                  !.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: !isSignUp ? Theme
                                                    .of(context)
                                                    .textTheme
                                                    .headline3
                                                    !.color : Theme
                                                    .of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                          ),
                                          !isSignUp
                                              ? Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Card(
                                              elevation: 0,
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              child: SizedBox(
                                                height: 6,
                                                width: 48,
                                              ),
                                            ),
                                          )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                            ),
                            AnimatedCrossFade(
                              alignment: Alignment.topCenter,
                              reverseDuration: Duration(milliseconds: 420),
                              duration: Duration(milliseconds: 420),
                              crossFadeState: !isSignUp ? CrossFadeState
                                  .showSecond : CrossFadeState.showFirst,
                              firstCurve: Curves.fastOutSlowIn,
                              secondCurve: Curves.fastOutSlowIn,
                              sizeCurve: Curves.fastOutSlowIn,
                              firstChild: IgnorePointer(
                                ignoring: !isSignUp,
                                child: Column(
                                  children: <Widget>[
                                    _emailUI(),
                                    _emailUINew(),
                                    _countryView(),
                                    _getSignUpButtonUI(),
                                  ],
                                ),
                              ),
                              secondChild: IgnorePointer(
                                ignoring: isSignUp,
                                child: Column(
                                  children: <Widget>[
                                    _loginTextUI(),
                                    _countryView(),
                                    _getSignInButtonUI(),
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
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    AppLocalizations.of('By clicking start, your agree to our'),
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    AppLocalizations.of('Terms and Conditions'),
                    textAlign: TextAlign.center,
                    style: Theme
                        .of(context)
                        .textTheme
                    .subtitle1
                        !.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8 + MediaQuery
                        .of(context)
                        .padding
                        .bottom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _facebookUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8, top: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: HexColor("#4267B2"),
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme
                  .of(context)
                  .dividerColor,
              blurRadius: 8,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.facebookF,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  AppLocalizations.of('Connect with facebook'),
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1
                      !.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _emailUI() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme
              .of(context)
              .dividerColor, width: 0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 48,
            child: Center(
              child: TextField(
                controller: fullnameController,
                maxLines: 1,
                onChanged: (txt) {
                  fullname = txt;
                },
                // style: TextStyle(
                //   // fontSize: 16,
                // ),
                // enabled: _isEditing,
                cursorColor: Theme
                    .of(context)
                    .primaryColor,
                decoration: new InputDecoration(
                  errorText: null,
                  border: InputBorder.none,
                  hintText: "Enter Fullname",
                  hintStyle: TextStyle(color: Theme
                      .of(context)
                      .disabledColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _emailUINew() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme
              .of(context)
              .dividerColor, width: 0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 48,
            child: Center(
              child: TextField(
                controller: emailController,
                maxLines: 1,
                onChanged: (txt) {
                  email = txt;
                },
                // style: TextStyle(
                //   // fontSize: 16,
                // ),
                // enabled: _isEditing,
                cursorColor: Theme
                    .of(context)
                    .primaryColor,
                keyboardType: TextInputType.emailAddress,
                decoration: new InputDecoration(
                  errorText: null,
                  border: InputBorder.none,
                  hintText: "Enter Email",
                  hintStyle: TextStyle(color: Theme
                      .of(context)
                      .disabledColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _loginTextUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 16, top: 30, bottom: 30),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          AppLocalizations.of('Login With Your Phone Number'),
          style: Theme
              .of(context)
              .textTheme
              .bodyText1
              !.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  Widget _countryView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 26),
      child: Container(
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme
              .of(context)
              .dividerColor, width: 0.6),
        ),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: _openCountryPickerDialog,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.6,
                          color: Theme
                              .of(context)
                              .dividerColor,
                        ),
                      ),
                      child: CountryPickerUtils.getDefaultFlagImage(
                          _selectedCountry),
                    ),
                    SizedBox(width: 8.0),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme
                          .of(context)
                          .dividerColor,
                    ),
                    SizedBox(width: 8.0),
                    Container(
                      color: Theme
                          .of(context)
                          .dividerColor,
                      height: 32,
                      width: 1,
                    )
                  ],
                ),
              ),
            ),
            Text("+${_selectedCountry.phoneCode} "),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 16),
                child: Container(
                  height: 48,
                  child: TextField(
                    maxLines: 1,
                    // controller: phoneNoController,
                    onChanged: (String txt) {
                      phoneNumber = txt.removeZeroInNumber;
                      //   if (phoneNumber.length > 5) {
                      //     _animationController.forward();
                      //   } else {
                      //     _animationController.reverse();
                      //   }
                    },
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    cursorColor: Theme
                        .of(context)
                        .primaryColor,
                    decoration: new InputDecoration(
                      errorText: null,
                      border: InputBorder.none,
                      hintText: AppLocalizations.of("Phone Number"),
                      hintStyle: TextStyle(color: Theme
                          .of(context)
                          .disabledColor),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _getSignUpButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () async {
              var connectivityResult = await (Connectivity()
                  .checkConnectivity());
              if (connectivityResult != ConnectivityResult.mobile &&
                  connectivityResult != ConnectivityResult.wifi) {
                // Fluttertoast.showToast(
                //     msg: "Device not connected to the internet, turn on your internet data",
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.BOTTOM,
                //     timeInSecForIosWeb: 6,
                //     backgroundColor: Colors.red,
                //     textColor: Colors.white,
                //     fontSize: 16.0
                // );
                FlutterToastr.show("Device not connected to the internet, turn on your internet data",context);
              } else {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      PhoneVerification(
                          "+${_selectedCountry.phoneCode}" + phoneNumber,
                          fullname, email)),
                );
              }
            },
            child: Center(
              child: Text(
                isSignUp ? AppLocalizations.of('Sign Up') : AppLocalizations.of(
                    'Next'),
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1
                    !.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _getSignInButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () async {
              var connectivityResult = await (Connectivity()
                  .checkConnectivity());
              if (connectivityResult != ConnectivityResult.mobile &&
                  connectivityResult != ConnectivityResult.wifi) {
                // Fluttertoast.showToast(
                //     msg: "Device not connected to the internet",
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.CENTER,
                //     timeInSecForIosWeb: 6,
                //     backgroundColor: Colors.red,
                //     textColor: Colors.white,
                //     fontSize: 16.0
                // );
                FlutterToastr.show("Device not connected to the internet", context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      PhoneLoginVerification(
                          "+${_selectedCountry.phoneCode}" + phoneNumber)),
                );
              }
            },
            child: Center(
              child: Text(
                isSignUp ? AppLocalizations.of('Sign Up') : AppLocalizations.of(
                    'Next'),
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1
                    !.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _openCountryPickerDialog() {
    Widget _buildDialogItem(Country country) =>
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.6,
                  color: Theme
                      .of(context)
                      .dividerColor,
                ),
              ),
              child: CountryPickerUtils.getDefaultFlagImage(country),
            ),
            SizedBox(width: 8.0),
            Expanded(
              // constraints: BoxConstraints(maxWidth: 140.0),
              child: Text(
                getCountryString(country.name),
                maxLines: 3,
                style: TextStyle(),
              ),
            ),
            Container(
              child: Text(
                "+${country.phoneCode}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  // fontSize: ConstanceData.SIZE_TITLE16,
                ),
              ),
            ),
          ],
        );
    showDialog(
        context: context,
        builder: (context) =>
            CountryPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: Theme
                  .of(context)
                  .primaryColor,
              searchInputDecoration: InputDecoration(
                  hintText: AppLocalizations.of('Search...')),
              isSearchable: true,
              title: Text(
                AppLocalizations.of('Select your country.'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onValuePicked: (Country country) =>
                  setState(() {
                    _selectedCountry = country;
                  }),
              itemBuilder: _buildDialogItem,
            ));
  }
    String getCountryString(String str) {
      var newString = '';
      var isFirstdot = false;
      for (var i = 0; i < str.length; i++) {
        if (isFirstdot == false) {
          if (str[i] != ',') {
            newString = newString + str[i];
          } else {
            isFirstdot = true;
          }
        }
      }
      return newString;
    }

  }