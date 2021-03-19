import 'dart:async';

import 'package:dovizkurlari/Kripto.dart';
import 'package:dovizkurlari/korona.dart';
import 'package:dovizkurlari/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashWidget(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Borsa> borsaitems = [];
  List<Altin> altinitems = [];
  final List<String> subsName = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CHF',
    'CAD',
    'RUB',
    'AUD',
    'AED',
  ];

  final List<String> altin = [
    'GA',
    'C',
    'Y',
    'T',
    'CMR',
    'ATA',
    '14',
    '18',
    '22',
    'GR',
    'XAU\/USD'
  ];
  var location;
  var locationau;

  Future<void> getDatas() async {
    location = await http.get('https://api.genelpara.com/embed/doviz.json');
    var dec = jsonDecode(location.body);
    print(borsaitems.length);
    if (borsaitems.length > 0) {
      borsaitems = [];
    }
    print(borsaitems.length);
    for (var i = 0; i < subsName.length; i++) {
      String loc = subsName[i];

      print(dec['$loc']);

      Borsa borsanew = Borsa(
        name: loc,
        alis: dec['$loc']['alis'],
        satis: dec['$loc']['satis'],
      );

      borsaitems.add(borsanew);
    }
    print(borsaitems.length);
  }

  Future<void> getDatasAltin() async {
    locationau = await http.get('https://api.genelpara.com/embed/altin.json');
    var decau = jsonDecode(locationau.body);
    print(altinitems.length);
    if (altinitems.length > 0) {
      altinitems = [];
    }
    print(altinitems.length);
    for (var i = 0; i < altin.length; i++) {
      String loc = altin[i];

      print(decau['$loc']);

      Altin borsanew = Altin(
        name: loc,
        alis: decau['$loc']['alis'],
        satis: decau['$loc']['satis'],
      );

      altinitems.add(borsanew);
    }
  }

  @override
  void initState() {
    getDatas();
    getDatasAltin();

    Timer(Duration(seconds: 5), () {
      setState(() {
        getDatas();
        getDatasAltin();
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Döviz Kurları',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_center),
              tooltip: 'Yardım',
              onPressed: () {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.amber,
                    content: Text(
                      'Güncel kur bilgileri  için yenile tuşuna basınız',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )));
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_chart),
              tooltip: 'Kripto Verileri',
              onPressed: () {
                setState(() {});
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Kripto()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.healing_outlined),
              tooltip: 'Korona Verileri',
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => KoronaVeri()));
                });
              },
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 40,
                ),
                tooltip: 'Yenile',
                onPressed: () {
                  setState(() {
                    getDatas();
                    getDatasAltin();
                    buildContainer(context);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Güncel veriler alındı.',
                        style: TextStyle(fontSize: 20),
                      )));
                },
              ),
              SizedBox(
                height: 20,
              ),

              Text(
                'Döviz',
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
                  itemCount: borsaitems.length,
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
                                  borsaitems[indeks].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Alış: ' + borsaitems[indeks].alis),
                                Text('Satış: ' + borsaitems[indeks].satis),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Text(
                'Altın',
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
                  itemCount: altinitems.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, indeks) {
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                          elevation: 2,
                          color: Colors.yellow,
                          child: Container(
                            height: 400,
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  altinitems[indeks].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Alış: ' + altinitems[indeks].alis),
                                Text('Satış: ' + altinitems[indeks].satis),
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
              //buildContainer(context)
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainer(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListView.builder(
        itemCount: borsaitems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, indeks) {
          return GestureDetector(
            onTap: () {},
            child: Card(
                elevation: 2,
                color: Colors.yellow[200],
                child: Container(
                  height: 400,
                  width: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        borsaitems[indeks].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Alış: ' + borsaitems[indeks].alis),
                      Text('Satış: ' + borsaitems[indeks].satis),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}

class SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new Scaffold(
          backgroundColor: Colors.white,
          body: MyHomePage(),
        ),
        title: new Text('Döviz Kurları'),
        image: new Image.asset('assets/tiger.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.red);
  }
}
