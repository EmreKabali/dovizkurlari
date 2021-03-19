import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class Kripto extends StatefulWidget {
  Kripto({Key key}) : super(key: key);

  @override
  _KriptoState createState() => _KriptoState();
}

class _KriptoState extends State<Kripto> {
  List<Kriptolar> kriptoitems = [];
  final List<String> subsName = [
    'BTC',
    'ETH',
    'XRP',
    'BCH',
    'LTC',
    'USDT',
    'EOS',
    'ADA',
    'XMR',
    'VEN',
    'TRX',
    'MANA',
  ];

  var location;

  Future<void> getDataskripto() async {
    location = await http.get('https://api.genelpara.com/embed/kripto.json');
    var dec = jsonDecode(location.body);
    print(kriptoitems.length);
    if (kriptoitems.length > 0) {
      kriptoitems = [];
    }
    print(kriptoitems.length);
    for (var i = 0; i < subsName.length; i++) {
      String loc = subsName[i];

      print(dec['$loc']);

      Kriptolar borsanew = Kriptolar(
        name: loc,
        alis: dec['$loc']['alis'],
        satis: dec['$loc']['satis'],
      );

      kriptoitems.add(borsanew);
    }
  }

  @override
  void initState() {
    getDataskripto();

    Timer(Duration(seconds: 1), () {
      setState(() {
        getDataskripto();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/bors.jpg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Kripto'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kripto',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.builder(
                  itemCount: kriptoitems.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, indeks) {
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                          elevation: 2,
                          color: Colors.blueAccent[200],
                          child: Container(
                            height: 400,
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  kriptoitems[indeks].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Alış: ' + kriptoitems[indeks].alis),
                                Text('Satış: ' + kriptoitems[indeks].satis),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
