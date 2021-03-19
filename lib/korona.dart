import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class KoronaVeri extends StatefulWidget {
  KoronaVeri({Key key}) : super(key: key);

  @override
  _KoronaVeriState createState() => _KoronaVeriState();
}

class _KoronaVeriState extends State<KoronaVeri> {
  List<KoronaData> kriptoitems = [];
  final List<String> subsName = [
    'gunluk_test',
    'gunluk_vaka',
    'gunluk_hasta',
    'gunluk_vefat',
    'gunluk_iyilesen',
    'toplam_test',
    'toplam_hasta',
    'toplam_vefat',
    'toplam_iyilesen',
    'agir_hasta_sayisi',
    'yatak_doluluk_orani',
  ];

  var location;

  Future<void> getDataskripto() async {
    location = await http.get('https://api.genelpara.com/embed/korona.json');
    var dec = jsonDecode(location.body);
    print(kriptoitems.length);
    if (kriptoitems.length > 0) {
      kriptoitems = [];
    }
    print(kriptoitems.length);
    for (var i = 0; i < subsName.length; i++) {
      String loc = subsName[i];

      print(dec['$loc']);

      KoronaData borsanew =
          KoronaData(name: loc, namevalue: dec['korona']['$loc']);

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
          title: Text('Korona Verileri'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Günlük Korona Verileri',
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
                          color: Colors.purple[300],
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
                                Text(kriptoitems[indeks].namevalue),
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
