import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmallflutter/firebase_options.dart';
import 'package:shoppingmallflutter/models/adress_provider.dart';
import 'package:shoppingmallflutter/models/category_provider.dart';
import 'package:shoppingmallflutter/models/product_provider.dart';
import 'package:shoppingmallflutter/models/member_provider.dart';
import 'package:shoppingmallflutter/screens/splash_screen.dart';
import 'package:provider/provider.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
late final FirebaseFirestore firestore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDefault();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => MemberProvider()),
          ChangeNotifierProvider(create: (_) => AdressProvider()),
        ],
        child: MyApp(),
      ),
  );
}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  auth = FirebaseAuth.instance;
  firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  print('Initialized default app $app');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const SplashScreenPage(title: 'Flutter Demo Home Page'),
    );
  }
}
