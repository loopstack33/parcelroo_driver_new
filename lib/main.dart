import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import 'package:parcelroo_driver_app/providers/multi_provider.dart';
import 'package:parcelroo_driver_app/service/fcm_services.dart';
import 'package:parcelroo_driver_app/service/local_notifications.dart';
import 'package:parcelroo_driver_app/utils/theme_constants.dart';
import 'package:parcelroo_driver_app/views/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isIOS){
    await Firebase.initializeApp();
  }
  else{
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBmbjQk7J1GaNeKGgxKtPdOp6qgHx5aqGk",
          authDomain: "parcelproo.firebaseapp.com",
          databaseURL: "https://parcelproo-default-rtdb.firebaseio.com",
          projectId: "parcelproo",
          storageBucket: "parcelproo.appspot.com",
          messagingSenderId: "1093985529453",
          appId: "1:1093985529453:web:c8f7f1bdb87ee5b90e1964",
          measurementId: "G-8PC0Z41W8V"
      ),
    );
  }
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await LocalNotificationsService.instance.initialize();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
  );

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FCMServices.fcmGetTokenandSubscribe('parcelroo');
  fcmListen();

  runApp(
      EasyLocalization(
          supportedLocales: const [
            Locale('en', 'US'),
          ],
          path: 'assets/languages',
          fallbackLocale: const Locale('en', 'US'),
          child: const MyApp()));
}

@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage event) async {

  if(event.data['id'].toString()== Globals.uid.toString()){
    LocalNotificationsService.instance.showNotification(
        title: '${event.notification?.title}',
        body: '${event.notification?.body}');

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      LocalNotificationsService.instance.showNotification(
          title: '${event.notification?.title}',
          body: '${event.notification?.body}');
    });
    log("Handling a background message: ${event.messageId}");
  }
  else if(event.data['id'].toString()=="0"){
    LocalNotificationsService.instance.showNotification(
        title: '${event.notification?.title}',
        body: '${event.notification?.body}');

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      LocalNotificationsService.instance.showNotification(
          title: '${event.notification?.title}',
          body: '${event.notification?.body}');
    });
    log("Handling a background message: ${event.messageId}");
  }

}

fcmListen() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {

    if(event.data['id'].toString()== FirebaseAuth.instance.currentUser?.uid) {
      LocalNotificationsService.instance.showNotification(
          title: '${event.notification?.title}',
          body: '${event.notification?.body}');

      FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    }
    else if(event.data['id'].toString()=="0"){
      LocalNotificationsService.instance.showNotification(
          title: '${event.notification?.title}',
          body: '${event.notification?.body}');

      FirebaseMessaging.onMessageOpenedApp.listen((message) {});
      log("Handling a background message: ${event.messageId}");
    }
  });

}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 875),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: multiProvider,
            child: MaterialApp(
              theme: kAppThemeData[AppTheme.light],
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: true,
                ),
                child: child!,
              ),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              title: 'Parcelroo Driver',

              home: child,
            ),
          );
        },
        child: const SplashScreen());
  }

}
