import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ChargeHelper {
  static Future<dynamic> chargeAmount(amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth = prefs.getString('auth');
    String? email = prefs.getString('email');
    print(email);
    var url = Uri.parse("https://api.paystack.co/transaction/charge_authorization"); // iOS
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer sk_live_9fbb6242290a1f4affff9dddf1942e882234af7f',
      },
      body: jsonEncode(<String, String>{
        'amount': amount.toString(),
        'email': email.toString(),
        'authorization_code': auth.toString()
      }),
    );
    if (response.statusCode == 200) {
      var status = response.statusCode;
      print(response);
      return status;
    } else {
      var body = json.decode(response.body);
      print(body);
      var status = response.statusCode;
      return status;
    }
  }
}