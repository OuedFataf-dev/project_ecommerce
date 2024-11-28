import 'package:e_commerce/pages/DetaillProduct.dart';
import 'package:e_commerce/pages/Home_page.dart';
import 'package:flutter/material.dart';
import './pages/authentification/login.dart';
import './pages/authentification/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'Services/provider.dart';
import 'package:provider/provider.dart';

import 'pages/AddProduct.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  // Exécution de l'application avec le ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create: (_) => PanierProvider(),
      child: MyApp(),
    ),
  );
}

//runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(
              product: [],
            ),
        '/home': (context) => const HomePage(
              product: [],
            ),
      },
    );
  }
}
