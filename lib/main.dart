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
import './pages/animation.dart';
import 'dart:async';
//import './pages/authentification/alertDilog.dart';

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
        '/': (context) => SplashScreen(),
        '/login': (context) => SignUp(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialisation de l'animation de mise à l'échelle
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: true);

    // Délai de 3 secondes avant de naviguer vers l'écran de connexion
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Animation du logo avec mise à l'échelle
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Image.asset(
                    'assets/images/scholarship.png', // Remplacer par votre image de logo
                    width: 150,
                    height: 150,
                  ),
                ),
                SizedBox(height: 20),
                // Indicateur de chargement
                CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 6,
                ),
                SizedBox(height: 50),
                // Texte d'accueil
                Column(
                  children: [
                    Text(
                      "Bienvenue dans ScholarApp!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Chargement...",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
