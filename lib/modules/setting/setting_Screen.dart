import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:riderapps/constance/routes.dart';
import 'package:riderapps/modules/setting/myProfile.dart';
import 'package:riderapps/modules/setting/privacy.dart';
import 'package:riderapps/constance/constance.dart' as constance;
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var fullName;
  var email;
  var phone;

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Widget build(BuildContext context) {
    getInfo();
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 150,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .padding
                        .top + 16,
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
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('Settings'),
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline5
                              !.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Theme
                      .of(context)
                      .dividerColor,
                ),
                MyProfile(),
                Container(
                  height: 1,
                  color: Theme
                      .of(context)
                      .dividerColor,
                ),
                SizedBox(
                  height: 16,
                ),
                PrivacyScreen(),
                SizedBox(
                  height: 32,
                ),
                Container(
                  color: Theme
                      .of(context)
                      .backgroundColor,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 1,
                        color: Theme
                            .of(context)
                            .dividerColor,
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.INTRODUCTION, (
                              Route<dynamic> route) => false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of('Log out'),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subtitle1
                                    !.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme
                                      .of(context)
                                      .disabledColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme
                            .of(context)
                            .dividerColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  selectLanguage(String languageCode) {
    constance.locale = languageCode;

    @override
    setCustomeLanguage(context, languageCode) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        AppLocalizations.of('Terms & Prvacy Policy'),
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline4!.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => VehicalManagement(),
                //   ),
                // );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Contact us'),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline4!.color,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      );
    }
    Widget myProfileDetail() {
      return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyProfile(),
            ),
          );
        },
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 14, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      fullName != null ? fullName: 'No name',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline4!.color,
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
        ),
      );
    }
    Widget userSettings() {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => VehicalManagement(),
                //   ),
                // );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Notifications'),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline5!.color,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DocmanagementScreen(),
                //   ),
                // );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Security'),
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline5!.color,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            InkWell(
              onTap: () {
             //   openShowPopupLanguage();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Language'),
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline4!.color,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            InkWell(
              onTap: () {
              //  openShowPopup();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Theme Mode'),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline4!.color,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      );
    }
    openShowPopup() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text(
                  AppLocalizations.of('Select theme mode'),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline4!.color,
                    fontSize: 18,
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          changeColor(light);
                        },
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Theme.of(context).textTheme.headline4!.color,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 32,
                            child: Text(
                              AppLocalizations.of('Light'),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          changeColor(dark);
                        },
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Theme.of(context).textTheme.headline4!.color,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 32,
                            child: Text(
                              AppLocalizations.of('Dark'),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });

    }
  }

  int light = 1;
  int dark = 2;
  changeColor(int color) {
    if (color == light) {
      MyApp.changeTheme(context);
    } else {
      MyApp.changeTheme(context);
    }
  }
}

