import 'package:flutter/material.dart';
import 'package:riderapps/Language/LanguageData.dart';
var isLight = true;
var primaryRiderColorString = '#028900';
var primaryDarkColorString = "#028900";
late AllTextData allTextData;
late Locale locale;
// ConnectivityBloc connectivityBloc;
Future refreshUser() async {
  // try {
  //   final _user = await auth.currentUser();
  //   if (_user == null) {
  //     riderUser = null;
  //     return;
  //   }
  //   riderUser = await RiderApiProvider()
  //       .getUserProfilebyPhon(_user.phoneNumber)
  //       .catchError((error) {
  //     return;
  //   });
  //   if (riderUser == null) return;
  //   if (locale != null) {
  //     riderUser.languageCode = locale.languageCode;
  //   }
  //   RiderApiProvider().updateUserlanguageCode(riderUser);
  //   liveRiderControlBloc.setInitial();
  //   setNotificationControlBlock();
  // } on Exception {}
}
  void setNotificationControlBlock() async {}