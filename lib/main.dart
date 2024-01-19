import 'dart:io';

import 'package:com.example.app_movil_proyecto_final/Screens/login_page.dart';
import 'package:com.example.app_movil_proyecto_final/inner_screens/category_screen.dart';
import 'package:com.example.app_movil_proyecto_final/inner_screens/on_view_screen.dart';
import 'package:com.example.app_movil_proyecto_final/inner_screens/manga_details.dart';
import 'package:com.example.app_movil_proyecto_final/models/mangas_models.dart';
import 'package:com.example.app_movil_proyecto_final/otros%20componentes/theme_data.dart';
import 'package:com.example.app_movil_proyecto_final/provider/dark_theme_provider.dart';
import 'package:com.example.app_movil_proyecto_final/providers/comment_provider.dart';
import 'package:com.example.app_movil_proyecto_final/providers/mangas_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'inner_screens/feed_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyBQpt0D9DHDAnGuMtfA6Oj0ZooqMYP5a6g',
              appId: '1:655295494265:android:156ee38e7ecf8361a6bca8',
              messagingSenderId: '655295494265',
              projectId: 'proyecto-final-d4144'))
      : await Firebase.initializeApp();
  await FlutterDownloader.initialize(); // Inicializar flutter_downloader
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          MangasModels(), // Aquí puedes inicializar la clase si es necesario
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  final Future<FirebaseApp> _fireBaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fireBaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('A ocurrido un error'),
                ),
              ),
            );
          }

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(create: (_) => MangasProvider()),
              ChangeNotifierProvider(create: (_) => CommentProvider()),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  home: LoginPage(),
                  routes: {
                    OnViewScreen.routeName: (ctx) => const OnViewScreen(),
                    FeedScreens.routeName: (ctx) => const FeedScreens(),
                    MangaDetails.routeName: (ctx) => const MangaDetails(),
                    CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                  });
            }),
          );
        });
  }
}
