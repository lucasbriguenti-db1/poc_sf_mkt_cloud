import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_sf_push/firebase_options.dart';
import 'package:poc_sf_push/notification/marketing_cloud_notification.dart';
import 'package:poc_sf_push/notification/notification_service.dart';
import 'package:sfmc_flutter/sfmc_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _setupSFMC();
  await notify();
  runApp(const MyApp());
}

final notificationService = NotificationService();

Future<void> notify() async {
  print(await FirebaseMessaging.instance.getToken());
  FirebaseMessaging.onMessage.listen(showNotification);
  FirebaseMessaging.onBackgroundMessage(showNotification);
}

Future<void> showNotification(RemoteMessage message) async {
  final notification = MarketingCloudNotification.fromMap(message.data);
  print(notification.toString());
  await notificationService.showNotification(notification);
}

Future<void> _setupSFMC() async {
  try {
    await SFMCSDK.setupSFMC(
      accessToken: "u6rBxyZZ3qIGco2mGXRrq7E5",
      appId: "fa2aefc7-f210-4112-8799-ba3f70467ee9",
      mid: "100015405",
      senderId: "662277545886",
      sfmcURL: "https://mc0sj9cbr9nkvs0xr6s-clln7zxq.device.marketingcloudapis.com/",
      delayRegistration: true,
    );
    print(await SFMCSDK.sdkState());
    await SFMCSDK.enablePush();
    print(await SFMCSDK.pushEnabled());
    await SFMCSDK.setContactKey('teste-apresentacao@teste.com');
  } catch (e) {
    print((e as PlatformException).message);
    print(e.stacktrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
