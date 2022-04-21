import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/themes.dart';
import 'package:riderapps/modules/wallet/cardPayment.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
String backendUrl = '{YOUR_BACKEND_URL}';

class PaymentMethod extends StatefulWidget {
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final plugin = PaystackPlugin();

  String transcation = 'No transcation Yet';
  Map<String, dynamic> _data = {};

  // static const platform = const MethodChannel('maugost.com/paystack_flutter');
  static const paystack_pub_key = "pk_test_f68c4c8bf31e9dbe7b821d5922cc06c29505f956";
  static const paystack_backend_url =
      "https://infinite-peak-60063.herokuapp.com";
  var publicKey = 'pk_live_9788e845e9c4098989720e1682facd83968aed3c';
  late DatabaseReference userCardDetails;
  String paystackPublicKey = 'pk_live_9788e845e9c4098989720e1682facd83968aed3c';
  var card_type = '';
  var didgits = '';
  var ref = randomAlphaNumeric(20);

  Future<CheckoutResponse> initPaystack() async {
    var UserId = FirebaseAuth.instance.currentUser!.uid;
    Charge charge = Charge()
      ..amount = 50 * 100
      ..reference = randomAlphaNumeric(20)
      ..email = 'customer@email.com';
    CheckoutResponse response = await plugin.checkout(context, method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,);
    print(response.reference);
    var refs = response.reference;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "https://api.paystack.co/transaction/verify/$refs"; // iOS
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer sk_live_9fbb6242290a1f4affff9dddf1942e882234af7f'
      },
    );
    if (res.statusCode == 200) {
      var st = convert.jsonDecode(res.body);
      print(st);
      var auth = st["data"]["authorization"]["authorization_code"];
      var lastDigits = st["data"]["authorization"]["last4"];
      var card_ = st["data"]["authorization"]["card_type"];
      prefs.setString('auth', auth);
      prefs.setString('lastDigits', lastDigits);
      prefs.setString('card_type', card_);
      setState(() {
        card_type = card_;
        didgits = lastDigits;
      });
      userCardDetails = FirebaseDatabase.instance.reference().child('userCardDetails/$UserId').push();
      Map userMap = {
        'auth': auth,
        'card_type': card_,
        'lastDigits' : lastDigits,
      };
      userCardDetails.set(userMap);
    }
    print(res.body);
    return response;
  }


  void getCardDetail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      didgits = prefs.getString('lastDigits')!;
      card_type = prefs.getString('card_type')!;
      print(didgits);
      print(didgits);
      print(didgits);
      print(didgits);
    });
  }

  @override
  void initState() {
    initPaystacks();
    getCardDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 194,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of('Done'),
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1
                                !.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                          AppLocalizations.of('Payment Method'),
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
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 14, left: 14, top: 16),
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16,
                                  bottom: 16,
                                  left: 24,
                                  right: 24),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Theme
                                        .of(context)
                                        .primaryColor,
                                    radius: 30,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 14,
                                      child: Icon(
                                        FontAwesomeIcons.dollarSign,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of('Cash'),
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .headline4
                                              !.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(
                                              'Default Payment Method'),
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
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Theme
                                  .of(context)
                                  .dividerColor,
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            flex: 6,
            child: ListView(
              padding: EdgeInsets.only(right: 14, left: 14),
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 14, left: 14, top: 14, bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('CREDIT CARD'),
                          style: Theme
                              .of(context)
                              .textTheme
                              .button
                              !.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .dividerColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Theme
                                .of(context)
                                .primaryColor, width: 1.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  card_type != null ? card_type : 'No card',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .button
                                      !.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  didgits != null
                                      ? '**** **** **** $didgits'
                                      : '123',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .button
                                      !.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Icon(
                                  Icons.check_circle,
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Container(
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    initPaystacks();
                    var resp = initPaystack();
                    print(resp);
                    print('Here');
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        AppLocalizations.of('Add New Method'),
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle1
                            !.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery
                .of(context)
                .padding
                .bottom + 16,
          )
        ],
      ),
    );
  }

  Future<void> initPaystacks() async {
    try {
      await plugin.initialize(
          publicKey: publicKey).then((value) => {
        print(value)
      });
      // Paystack is ready for use in receiving payments
    } on PlatformException {
      // well, error, deal with it
      print('error');
    }
  }


}