import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:riderapps/Language/LanguageData.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:riderapps/constance/global.dart' as globals;
import 'package:riderapps/constance/routes.dart';
import 'package:riderapps/constance/themes.dart';

import 'package:riderapps/constance/constance.dart' as constance;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late BuildContext myContext;

  @override
  void initState() {
    myContext = context;
    _loadNextScreen();
    animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    animationController.forward();
    super.initState();
  }

  _loadNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    if (constance.allTextData == null) {
      constance.allTextData =
          AllTextData.fromJson(json.decode(await DefaultAssetBundle.of(myContext).loadString("assets/jsonFile/languagetext.json")));
    }
    checkUserStatus();
  }

  checkUserStatus() {
    Navigator.pushReplacementNamed(context, Routes.INTRODUCTION);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globals.locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: MediaQuery.of(context).size.width),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SizedBox(),
              ),
              SizedBox(
                width: 150,
                height: 150,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget ?child) {
                    return Transform(
                      transform: new Matrix4.translationValues(
                          0.0,
                          80 *
                              (1.0 -
                                  (AlwaysStoppedAnimation(Tween(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn)))
                                          .value)
                                      .value),
                          0.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38.0),
                        ),
                        elevation: 12,
                        child: Image.asset(ConstanceData.appIcon),
                      ),
                    );
                  },
                ),
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget ?child) {
                  return Transform(
                    transform: new Matrix4.translationValues(
                        0.0,
                        120 *
                            (1.0 -
                                (AlwaysStoppedAnimation(Tween(begin: 0.2, end: 1.0)
                                            .animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn)))
                                        .value)
                                    .value),
                        0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Opacity(
                        opacity: animationController.value,
                        child: Text(
                          AppLocalizations.of('My Cab'),
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: SizedBox(),
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget ?child) {
                  return Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Transform(
                        transform: new Matrix4.translationValues(
                            0.0,
                            160 *
                                (1.0 -
                                    (AlwaysStoppedAnimation(Tween(begin: 0.4, end: 1.0)
                                                .animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn)))
                                            .value)
                                        .value),
                            0.0),
                        child: Image.asset(
                          ConstanceData.buildingImageBack,
                          color: HexColor("#FF8B8B"),
                        ),
                      ),
                      Transform(
                        transform: new Matrix4.translationValues(
                            0.0,
                            160 *
                                (1.0 -
                                    (AlwaysStoppedAnimation(Tween(begin: 0.8, end: 1.0)
                                                .animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn)))
                                            .value)
                                        .value),
                            0.0),
                        child: Image.asset(
                          ConstanceData.buildingImage,
                          color: HexColor("#FFB8B8"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
