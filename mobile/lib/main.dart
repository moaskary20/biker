import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/common/controllers/theme_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/blog/controllers/blog_controller.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/notification_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/theme/dark_theme.dart';
import 'package:sixam_mart/theme/light_theme.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/cookies_view.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('main started');

  if(ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();

  /*///Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };


  ///Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };*/

  if(GetPlatform.isWeb){
    print('Platform: Web');
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: const FirebaseOptions(
          apiKey: "AIzaSyDFbGykyJhP_amLPY1AopqWhFdCyulPaG0",
          authDomain: "biker-10e02.firebaseapp.com",
          projectId: "biker-10e02",
          storageBucket: "biker-10e02.firebasestorage.app",
          messagingSenderId: "891109656540",
          appId: "1:891109656540:web:d05ff86236675bc5fd7119",
          measurementId: "G-MH14RY046J"
        ));
      }
    } catch (e) {
      if (e.toString().contains('A Firebase App named "[DEFAULT]" already exists')) {
        print('Firebase already initialized (caught duplicate-app error, web)');
      } else {
        rethrow;
      }
    }
  } else if(GetPlatform.isAndroid) {
    print('Platform: Android');
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyDFbGykyJhP_amLPY1AopqWhFdCyulPaG0",
            appId: "1:891109656540:web:d05ff86236675bc5fd7119",
            messagingSenderId: "891109656540",
            projectId: "biker-10e02",
          ),
        );
      }
    } catch (e) {
      if (e.toString().contains('A Firebase App named "[DEFAULT]" already exists')) {
        print('Firebase already initialized (caught duplicate-app error, android)');
      } else {
        rethrow;
      }
    }
  } else {
    print('Platform: Other');
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (e) {
      if (e.toString().contains('A Firebase App named "[DEFAULT]" already exists')) {
        print('Firebase already initialized (caught duplicate-app error, other)');
      } else {
        rethrow;
      }
    }
  }

  print('Firebase initialized');
  Map<String, Map<String, String>> languages = await di.init();
  print('Languages loaded');

  NotificationBodyModel? body;
  try {
    if (GetPlatform.isMobile) {
      print('Mobile platform detected');
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        print('Remote message received');
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
      print('Firebase Messaging initialized');
    }
  }catch(e) { print('Error in Firebase Messaging:'); print(e); }

  if (ResponsiveHelper.isWeb()) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "380903914182154",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  print('Running app...');
  
  // Initialize BlogController early to avoid registration issues
  try {
    if (Get.isRegistered<BlogController>()) {
      print('BlogController already registered');
    } else {
      print('BlogController not registered, will be lazy loaded');
    }
  } catch (e) {
    print('Error checking BlogController registration: $e');
  }
  
  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    _route();
  }

  void _route() async {
    if(GetPlatform.isWeb) {
       Get.find<SplashController>().initSharedData();
      if(AddressHelper.getUserAddressFromSharedPref() != null && AddressHelper.getUserAddressFromSharedPref()!.zoneIds == null) {
        Get.find<AuthController>().clearSharedAddress();
      }

      if(!AuthHelper.isLoggedIn() && !AuthHelper.isGuestLoggedIn() /*&& !ResponsiveHelper.isDesktop(Get.context!)*/) {
        await Get.find<AuthController>().guestLogin();
      }

      if((AuthHelper.isLoggedIn() || AuthHelper.isGuestLoggedIn()) && Get.find<SplashController>().cacheModule != null) {
        Get.find<CartController>().getCartDataOnline();
      }

      Get.find<SplashController>().getConfigData(loadLandingData: (GetPlatform.isWeb && AddressHelper.getUserAddressFromSharedPref() == null), fromMainFunction: true);

    }
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null) ? const SizedBox() : GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
            ),
            theme: themeController.darkTheme ? dark() : light(),
            locale: localizeController.locale,
            translations: Messages(languages: widget.languages),
            fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
            initialRoute: GetPlatform.isWeb ? RouteHelper.getInitialRoute() : RouteHelper.getSplashRoute(widget.body),
            getPages: RouteHelper.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
            builder: (BuildContext context, widget) {
              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)), child: Material(
                child: Stack(children: [

                  widget!,

                  GetBuilder<SplashController>(builder: (splashController){
                    if(!splashController.savedCookiesData && !splashController.getAcceptCookiesStatus(splashController.configModel != null ? splashController.configModel!.cookiesText! : '')){
                      return ResponsiveHelper.isWeb() ? const Align(alignment: Alignment.bottomCenter, child: CookiesView()) : const SizedBox();
                    }else{
                      return const SizedBox();
                    }
                  })
                ]),
              ));
          },
          );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}