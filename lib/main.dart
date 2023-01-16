import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animations/animations.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config.dart';
import 'dart:io';

import 'schedule/schedule.dart';
import 'food/food.dart';
import 'absent.dart';
import 'settings/settings.dart';

void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('database');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
    currentGroupGuid.addListener(() {
      setState(() {});
    });
    currentLoginStatus.addListener(() {
      setState(() {});
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KTC Appen',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          elevation: 2,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green, brightness: Brightness.dark),
          useMaterial3: true,
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.white,
          )
          /* dark theme settings */
          ),
      themeMode: currentTheme.currentTheme(),
      home: const MyHomePage(title: 'KTC Appen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;

  final _pageList = <Widget>[
    SchedulePage(currentGroupGuid: currentGroupGuid),
    const FoodPage(),
    AbsentPage(currentLoginStatus: currentLoginStatus),
    SettingsPage(
        currentGroupGuid: currentGroupGuid,
        currentLoginStatus: currentLoginStatus),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          child,
          animation,
          secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _pageList[_pageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            _pageIndex = index;
          });
        },
        selectedIndex: _pageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.schedule),
            label: 'Schema',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant),
            label: 'Matsedel',
          ),
          NavigationDestination(
            icon: Icon(Icons.sick),
            label: 'Frånvarande',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Inställningar',
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
