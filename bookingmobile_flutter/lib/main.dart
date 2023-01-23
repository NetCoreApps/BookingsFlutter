import 'package:bookingmobile_flutter/todo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:servicestack/web_client.dart' if (dart.library.io) 'package:servicestack/client.dart';
import 'dart:io';

import 'bookings.dart';
import 'dtos.dart';

var baseUrl = "https://localhost:5001";

var client = ClientFactory.create(baseUrl);

void main() {
  if (!kReleaseMode && !kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
    if (Platform.isAndroid) {
      baseUrl = "https://10.0.2.2:5001";
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      baseUrl = "https://localhost:5001";
    } else if (Platform.isIOS) {
      baseUrl = "https://localhost:5001";
    }
  }

  client = ClientFactory.create(baseUrl);
  client.post(Authenticate(
    provider: 'credentials',
    userName: 'admin@email.com',
    password: 'p@55wOrd'
  ));

  runApp(const BookingMobile());
}

class BookingMobile extends StatelessWidget {
  const BookingMobile({super.key});

  static IServiceClient getClient() {
    return client;
  }

  static void authenticateClient() {

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
                bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.hotel))
            ])),
            body: const TabBarView(children: [
              HelloFlutter(title: "Home"),
              TodoPage(title: "Todo Application"),
              BookingsPage(title: "Bookings"),
            ]),
          ),
        ) //const HelloFlutter(title: 'Flutter Demo Home Page'),
        );
  }
}

class HelloFlutter extends StatefulWidget {
  const HelloFlutter({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StatefulWidget> createState() => HelloFlutterState();
}

class HelloFlutterState extends State<HelloFlutter> {
  //State for this widget
  String result = "";
  var myController = TextEditingController();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    myController.addListener(callService);
  }

  Future<void> callService() {
    var text = myController.text.isEmpty ? "World" : myController.text;
    return client.get(Hello(name: text)).then((value) => setState(() {
      result = value.result!;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Hello API',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'World',
                    ),
                    controller: myController,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Result: $result',
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 30, left: 8),
                      child: Text(
                        'You have pushed the button this many times:',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 30),
                      child: Text(
                        '$_counter',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// Use only in debug to make it easy to access localhost API service.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
