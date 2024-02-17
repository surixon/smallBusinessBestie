import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smalll_business_bestie/provider/loading_provider.dart';
import 'package:smalll_business_bestie/provider/theme_provider.dart';
import 'package:smalll_business_bestie/routes.dart';
import 'package:smalll_business_bestie/theme/theme_color.dart';
import 'package:smalll_business_bestie/widgets/loading_widget.dart';

import 'constants/dimensions_constants.dart';
import 'constants/string_constants.dart';
import 'firebase_options.dart';
import 'globals.dart';
import 'helpers/custom_scroll_behavior.dart';
import 'helpers/shared_pref.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();

  if(Platform.isAndroid){
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }else{
    await Firebase.initializeApp();
  }

  await EasyLocalization.ensureInitialized();

  SharedPref.prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider(mainTheme)),
      ChangeNotifierProvider(create: (context) => LoadingProvider())
    ],
    child: EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child:  const MyApp(),
    ),
  ));

  setupLocator();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ScreenUtilInit(
        designSize: Size(
            DimensionsConstants.screenWidth, DimensionsConstants.screenHeight),
        builder: (context, child) => MaterialApp.router(
            builder: (c, widget) {
              widget = FToastBuilder()(c, widget!);
              widget = LoadingScreen.init()(c, widget);
              return widget;
            },
            debugShowCheckedModeBanner: false,
            title: appName,
            theme: themeProvider.themeData,
            routerConfig: router,
            scrollBehavior: CustomScrollBehavior(),
            scaffoldMessengerKey: Globals.scaffoldMessengerKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale));
  }
}
