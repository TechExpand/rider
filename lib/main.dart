import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Language/appLocalizations.dart';
import 'constance/constance.dart' as constance;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constance/constance.dart';
import 'constance/themes.dart';
import 'modules/home/acceptSheet.dart';
import 'modules/home/home_screen.dart';
import 'modules/dataProviders/appData.dart';
import 'modules/splash/SplashScreen.dart';
import 'modules/splash/introductionScreen.dart';
import 'constance/global.dart' as globals;
import 'constance/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;
double lat = 6.3350;
double long = 5.6037;
void setUpGeolocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  currentPosition = position;
  print(position);
  lat = currentPosition.latitude;
  long = currentPosition.longitude;
}

Future<void> main() async {
  setUpGeolocation();
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'rider_AWWWWAYRTUYIIOYTYEUTfghgdhtdtydtegeeegggesdewewystrdthcfUAAAA',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:857799891310:android:019a82e1fa513e7eeb497f',
            apiKey: 'AIzaSyCK99s7C_FxciM1SnJurqzekp8rMPsQSpI',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '857799891310',
            databaseURL: 'https://shamrock-d19cf-default-rtdb.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:857799891310:android:019a82e1fa513e7eeb497f',
            apiKey: 'AIzaSyCK99s7C_FxciM1SnJurqzekp8rMPsQSpI',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '857799891310',
            databaseURL: 'https://shamrock-d19cf-default-rtdb.firebaseio.com',
          ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new MyApp()));
}

class MyApp extends StatefulWidget {
  static changeTheme(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeTheme();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = new UniqueKey();
  late Position currentPosition;

  void changeTheme() {
    this.setState(() {
      globals.isLight = !globals.isLight;
    });
    String locale = "en";
    setLanguage(String languageCode) {
      setState(() {
        locale = languageCode;
        constance.locale = languageCode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    constance.locale = locale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      globals.isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness:
      Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: CoustomTheme
          .getThemeData()
          .cardColor,
      systemNavigationBarDividerColor:
      CoustomTheme
          .getThemeData()
          .disabledColor,
      systemNavigationBarIconBrightness:
      globals.isLight ? Brightness.dark : Brightness.light,
    ));
    return Container(
      key: key,
      color: CoustomTheme
          .getThemeData()
          .backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CoustomTheme
                  .getThemeData()
                  .backgroundColor,
              CoustomTheme
                  .getThemeData()
                  .backgroundColor,
              CoustomTheme
                  .getThemeData()
                  .backgroundColor
                  .withOpacity(0.8),
              CoustomTheme
                  .getThemeData()
                  .backgroundColor
                  .withOpacity(0.7)
            ],
          ),
        ),
        child: ChangeNotifierProvider(
          create: (context) => new AppData(),
          child: RootRestorationScope(
            restorationId: 'root',
            child: MaterialApp(
              // localizationsDelegates: [
              //   // GlobalMaterialLocalizations.delegate,
              //   // GlobalWidgetsLocalizations.delegate,
              //   // GlobalCupertinoLocalizations.delegate,
              // ],
              // supportedLocales: [
              //   const Locale('en'), // English
              //   const Locale('fr'), // French
              //   const Locale('ar'), // Arabic
              // ],
              debugShowCheckedModeBanner: false,
              // title: AppLocalizations.of('Shamrock'),
              home: FirebaseAuth.instance.currentUser != null
                  ? HomeScreen(lat, long)
                  : SplashScreen(),
              //  initialRoute: ( FirebaseAuth.instance.currentUser != null) ? Routes.SPLASH  : Routes.HOME,
              routes: routes,
              theme: CoustomTheme.getThemeData(),
              // builder: (BuildContext context, Widget ?child) {
              //   return Directionality(
              //     textDirection: TextDirection.ltr,
              //     child: Builder(
              //       builder: (BuildContext context) {
              //         return MediaQuery(
              //           data: MediaQuery.of(context).copyWith(
              //             textScaleFactor: 1.0,
              //           ),
              //           child: child,
              //         );
              //       },
              //     ),
              //   );
              // },
            ),
          ),
        ),
      ),
    );
  }


  var routes = <String, WidgetBuilder>{
    Routes.INTRODUCTION: (BuildContext context) => IntroductionScreen(),
    Routes.HOME: (BuildContext context) => HomeScreen(lat, long),
  };
}





