import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
String backendUrl = '{YOUR_BACKEND_URL}';

class cardPayment extends StatefulWidget {
  @override
  _cardPayment createState() => _cardPayment();

}

class _cardPayment extends State<cardPayment> {
  final plugin = PaystackPlugin();

  String _message = '';
  bool _paymentReady = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Platform messages are asynchronous, so we initialize in an async method.
  String transcation = 'No transcation Yet';
  Map<String, dynamic> _data = {};
  // static const platform = const MethodChannel('maugost.com/paystack_flutter');
  static const paystack_pub_key = "pk_test_f68c4c8bf31e9dbe7b821d5922cc06c29505f956";
  static const paystack_backend_url =
      "https://infinite-peak-60063.herokuapp.com";
  String paystackPublicKey = '{pk_test_f68c4c8bf31e9dbe7b821d5922cc06c29505f956}';

  @override
  void initState() {
    plugin.initialize(
        publicKey: paystack_pub_key);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                Text(
                  'Done',
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
          SafeArea(
            child: Column(
              children: <Widget>[
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true, onCreditCardWidgetChange: (CreditCardBrand ) {  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CreditCardForm(
                          cardNumber: "",
                          cardHolderName: "",
                          cvvCode: "",
                          themeColor: Colors.red,
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumberDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                          ),
                          expiryDateDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Card Holder',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange, expiryDate: '',
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: const Text(
                              'Validate',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'halter',
                                fontSize: 14,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                          color: const Color(0xff1b447b),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              print('valid!');
                            } else {
                              print('invalid!');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

}

