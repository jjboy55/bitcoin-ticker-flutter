import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String apiKey = '8F764FB5-BA88-4FF3-BDB0-E9ACE20D0FE6';
const String appURL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<dynamic> coinApiDataRequest(String currencyState) async {
    Map<String, String> coinValuePairs = {};
    for (String crypto in cryptoList) {
      http.Response response = await http
          .get(Uri.parse('$appURL/$crypto/$currencyState?apikey=$apiKey'));
      if (response.statusCode == 200) {
        var decodedCoinApiData = jsonDecode(response.body);
        coinValuePairs[crypto] = decodedCoinApiData['rate'].toStringAsFixed(2);
      } else {
        print(response.statusCode);
      }
    }
    return coinValuePairs;
  }
}
