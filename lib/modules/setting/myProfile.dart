import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var fullName;
  var email;
  var phone;
  var credit;
  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
      credit = prefs.getInt('oldAmount');
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
                height: 160,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('My Account'),
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline4
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
                Container(
                  height: 1,
                  color: Theme
                      .of(context)
                      .dividerColor,
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Theme
                      .of(context)
                      .dividerColor,
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Name'),
                  subtext: fullName != null ? fullName : 'No name',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme
                        .of(context)
                        .dividerColor,
                  ),
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Email'),
                  subtext: email != null ? email : 'No email',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme
                        .of(context)
                        .dividerColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme
                        .of(context)
                        .dividerColor,
                  ),
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Phone Number'),
                  subtext: phone != null ? phone : 'No phone',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme
                        .of(context)
                        .dividerColor,
                  ),
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Outstanding payment'),
                  subtext: credit != null ? credit.toString() : '0',
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
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 240,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}

class MyAccountInfo extends StatefulWidget {
  final  headText;
  final  subtext;
  const MyAccountInfo({this.headText, this.subtext});
  @override
  _MyAccountInfoState createState() => _MyAccountInfoState();
}
class _MyAccountInfoState extends State<MyAccountInfo> {
  var fullName;
  var email;
  var phone;
  var credit;
  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
      credit = prefs.getInt('oldAmount');
    });
  }
  @override
  void initState() {
    super.initState();
    getInfo();
  }
  @override
  Widget build(BuildContext context) {
    getInfo();
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 16, top: 20, bottom: 20),
        child: Row(
          children: <Widget>[
            Text(
              widget.headText,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Theme.of(context).textTheme.headline4!.color,
              ),
            ),
            Expanded(child: SizedBox()),
            Text(
              widget.subtext,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontSize: 16.0,
                color: Theme.of(context).disabledColor,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 22,
              color: Theme.of(context).disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}