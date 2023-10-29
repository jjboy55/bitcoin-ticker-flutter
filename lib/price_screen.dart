import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  List<Widget> getPickerItems() {
    List<Widget> pickerList = [];
    for (String currencies in currenciesList) {
      var pickerItem = Text(currencies);
      pickerList.add(pickerItem);
    }
    return pickerList;
  }

  int selectedCurrency = 0;
  String selectedState = 'AUD';
  String currentRates = '0';
  Map<String, String> coinValuePairsInScreen = {};
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    getOverallRates();
  }

  void getOverallRates() async {
    CoinData coinData = CoinData();
    isWaiting = true;
    var decodedCoinApiData = await coinData.coinApiDataRequest(selectedState);
    isWaiting = false;
    setState(() {
      coinValuePairsInScreen = decodedCoinApiData;
    });
  }

  CupertinoPicker getCupertino() => CupertinoPicker(
        itemExtent: 32.0,
        scrollController: FixedExtentScrollController(
          initialItem: selectedCurrency,
        ),
        onSelectedItemChanged: (onSelectedItemChanged) {
          setState(() {
            selectedCurrency = onSelectedItemChanged;
            selectedState = currenciesList[selectedCurrency];
          });
          getOverallRates();
        },
        children: getPickerItems(),
      );

  Column makeNewCard() {
    List<CryptoCard> cryptoCardList = [];
    for (String crypto in cryptoList) {
      CryptoCard card = CryptoCard(
          currentRates: isWaiting ? '?' : coinValuePairsInScreen[crypto],
          selectedState: selectedState,
          cryptoCurrency: crypto);
      cryptoCardList.add(card);
    }
    return Column(
      children: cryptoCardList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeNewCard(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getCupertino(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.currentRates,
    required this.selectedState,
    required this.cryptoCurrency,
  });

  final String? currentRates;
  final String selectedState;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $currentRates $selectedState',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// DropdownButton(
// value: selectedValue,
// items: getDropDownMenuItems(),
// onChanged: (value) {
// setState(() {
// selectedValue = value;
// });
// },
// ),
// List<DropdownMenuItem> getDropDownMenuItems() {
//   List<DropdownMenuItem<String>> dropDownList = [];
//   for (String currencies in currenciesList) {
//     var newItem = DropdownMenuItem(
//       child: Text(currencies),
//       value: currencies,
//     );
//     dropDownList.add(newItem);
//   }
//   return dropDownList;
// }
