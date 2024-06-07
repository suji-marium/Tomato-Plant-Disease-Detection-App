
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:loginsuji/Screen/LoginScreen.dart';
import 'package:loginsuji/provider/user_provider.dart';
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        splash: SizedBox(
            height: 1000,
            width: 1000,
            child: Container(
              height: 1000,
            width: 1000,
              child: Image.asset(
                "assets/AGROGUARD.png",
                fit: BoxFit.contain,
              )
      
            )
            ),
      
        nextScreen: WeeklyPackage(),
        splashTransition: SplashTransition.scaleTransition,
        //backgroundColor: Colors.white,
        
      ),

    );
  }
}




class WeeklyPackage extends StatefulWidget {
  @override
  _WeeklyPackageState createState() => _WeeklyPackageState();
}

class _WeeklyPackageState extends State<WeeklyPackage> {
  @override
  
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Email and Password Login',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return LoginScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}


