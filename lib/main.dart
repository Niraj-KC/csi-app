import 'package:csi_app/screens/drawer_screens/board_members_csi.dart';
import 'package:csi_app/screens/on_boading_screens/splash_screen.dart';
import 'package:csi_app/screens/providers/bottom_navigation_provider.dart';
import 'package:csi_app/screens/providers/drawer_option_provider.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';

late Size mq ;
bool isKeyboardOpen = false ;

void main(){
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>BottomNavigationProvider()),
        ChangeNotifierProvider(create: (context)=>DrawerOptionProvider()),
      ],
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerOptionProvider>(
      builder: (context,drawerOp,child)=>MaterialApp(
        debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
          // home: SplashScreen(drawerOp: drawerOp,)
          home: BoardMemberCSI(drawerOp: drawerOp),
      ),
    )
    ;
  }
}
