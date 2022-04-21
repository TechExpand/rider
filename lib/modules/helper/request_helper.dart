import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class RequestHelper {
  static Future<dynamic> getRequest(String url) async {
    var urls = Uri.parse(url);
    http.Response response = await http.get(urls);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }

  Future<int> chargeAmount(amount, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth = prefs.getString('auth');
    var url = Uri.parse("https://api.paystack.co/transaction/charge_authorization"); // iOS
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer sk_test_644ff7e9f679a6ecfc3152e30ad453611e0e564e',
      },
      body: jsonEncode(<String, String>{
        'amount': amount,
        'email': email,
        'authorization_code': auth.toString()
      }),
    );
    if (response.statusCode == 200) {
      var status = response.statusCode;
      return status;
    } else {
      var status = response.statusCode;
      return status;
    }
  }

}