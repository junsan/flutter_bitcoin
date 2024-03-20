import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'coin_data.dart';
import 'services/rate_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String? selectedCurrency = 'USD';
  dynamic? rateBTC = '?';
  dynamic? rateETH = '?';
  dynamic? rateLTC = '?';

  List<DropdownMenuItem<String>> getDropDownItems() {
    List<DropdownMenuItem<String>> dropDownItem = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropDownItem.add(newItem);
    }

    return dropDownItem;
  }

  Future<dynamic> getExchangeRate(selectedCurr, btc) async {
    http.Response response = await http.get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/$btc/$selectedCurr?apikey=983ECE65-A864-43BE-842F-9C1C9B824C3E'));
    String data = response.body;
    return jsonDecode(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RateCard(rateBTC: rateBTC, selectedCurrency: selectedCurrency, name: 'BTC'),
                RateCard(rateBTC: rateETH, selectedCurrency: selectedCurrency, name: 'ETH'),
                RateCard(rateBTC: rateLTC, selectedCurrency: selectedCurrency, name: 'LTC'),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: DropdownButton(
              value: selectedCurrency,
              items: getDropDownItems(),
              onChanged: (value) async {
                var dataBTC = await getExchangeRate(value, 'BTC');
                var dataETH = await getExchangeRate(value, 'ETH');
                var dataLTC = await getExchangeRate(value, 'LTC');
                rateBTC = double.parse(dataBTC['rate']!.toStringAsFixed(2));
                rateETH = double.parse(dataETH['rate']!.toStringAsFixed(2));
                rateLTC = double.parse(dataLTC['rate']!.toStringAsFixed(2));
                setState(() {
                  selectedCurrency = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
