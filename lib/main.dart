// lib/main.dart
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sixvalley_ecommerce/data/local/cache_response.dart';

// Controllers
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/facebook_login_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/google_login_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/controllers/compare_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/contact_us/controllers/contact_us_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/controllers/coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/location/controllers/location_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/controllers/loyalty_point_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/controllers/refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/reorder/controllers/re_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/restock/controllers/restock_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/controllers/support_ticket_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wallet/controllers/wallet_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';

// ✅ These three were missing (and caused your errors):
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart'; // note the double 'rr'

import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/screens/splash_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/app_localization.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/push_notification/models/notification_body.dart';
import 'package:flutter_sixvalley_ecommerce/push_notification/notification_helper.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/dark_theme.dart';
import 'package:flutter_sixvalley_ecommerce/theme/light_theme.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:provider/provider.dart';

import 'di_container.dart' as di;
import 'helper/custom_delegate.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final database = AppDatabase();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dev-only: bypass bad certs
  HttpOverrides.global = MyHttpOverrides();

  if (Firebase.apps.isEmpty) {
    if (Platform.isAndroid) {
      try {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyDTc2kh9Y42vUK6_mBpCIw-663dCvZigbE",
            projectId: "ahiaoma-1084f",
            messagingSenderId: "986297342898",
            appId: "1:986297342898:android:58f62670a70d11b18c62ab",
          ),
        );
      } catch (_) {
        await Firebase.initializeApp();
      }
    } else {
      await Firebase.initializeApp();
    }
  }

  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await di.init();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  NotificationBody? body;
  try {
    final RemoteMessage? initial =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      body = NotificationHelper.convertNotification(initial.data);
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (_) {}

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<CategoryController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ShopController>()),           // ✅ now imported
        ChangeNotifierProvider(create: (_) => di.sl<FlashDealController>()),
        ChangeNotifierProvider(create: (_) => di.sl<FeaturedDealController>()),
        ChangeNotifierProvider(create: (_) => di.sl<BrandController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProductController>()),
        ChangeNotifierProvider(create: (_) => di.sl<BannerController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProductDetailsController>()),
        ChangeNotifierProvider(create: (_) => di.sl<OnBoardingController>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthController>()),
        ChangeNotifierProvider(create: (_) => di.sl<SearchProductController>()),  // ✅ now imported
        ChangeNotifierProvider(create: (_) => di.sl<CouponController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ChatController>()),
        ChangeNotifierProvider(create: (_) => di.sl<OrderController>()),
        ChangeNotifierProvider(create: (_) => di.sl<NotificationController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProfileController>()),       // ✅ file has double 'rr'
        ChangeNotifierProvider(create: (_) => di.sl<WishListController>()),
        ChangeNotifierProvider(create: (_) => di.sl<SplashController>()),
        ChangeNotifierProvider(create: (_) => di.sl<CartController>()),
        ChangeNotifierProvider(create: (_) => di.sl<SupportTicketController>()),
        ChangeNotifierProvider(create: (_) => di.sl<LocalizationController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ThemeController>()),
        ChangeNotifierProvider(create: (_) => di.sl<GoogleSignInController>()),
        ChangeNotifierProvider(create: (_) => di.sl<FacebookLoginController>()),
        ChangeNotifierProvider(create: (_) => di.sl<AddressController>()),
        ChangeNotifierProvider(create: (_) => di.sl<WalletController>()),
        ChangeNotifierProvider(create: (_) => di.sl<CompareController>()),
        ChangeNotifierProvider(create: (_) => di.sl<CheckoutController>()),
        ChangeNotifierProvider(create: (_) => di.sl<LoyaltyPointController>()),
        ChangeNotifierProvider(create: (_) => di.sl<LocationController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ContactUsController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ShippingController>()),
        ChangeNotifierProvider(create: (_) => di.sl<OrderDetailsController>()),
        ChangeNotifierProvider(create: (_) => di.sl<RefundController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ReOrderController>()),
        ChangeNotifierProvider(create: (_) => di.sl<ReviewController>()),
        ChangeNotifierProvider(create: (_) => di.sl<SellerProductController>()),
        ChangeNotifierProvider(create: (_) => di.sl<RestockController>()),
      ],
      child: MyApp(body: body),
    ),
  );
}

class MyApp extends StatelessWidget {
  final NotificationBody? body;
  const MyApp({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final locals = [
      for (final lang in AppConstants.languages)
        Locale(lang.languageCode!, lang.countryCode),
    ];

    return Consumer<ThemeController>(
      builder: (context, themeController, _) {
        return MaterialApp(
          title: AppConstants.appName,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: themeController.darkTheme
              ? dark(
                  primaryColor:
                      themeController.selectedPrimaryColor ?? const Color(0xFF107A2B),
                  secondaryColor:
                      themeController.selectedSecondaryColor ?? const Color(0xFFD4A124),
                )
              : light(
                  primaryColor:
                      themeController.selectedPrimaryColor ?? const Color(0xFF107A2B),
                  secondaryColor:
                      themeController.selectedSecondaryColor ?? const Color(0xFFD4A124),
                ),
          locale: Provider.of<LocalizationController>(context).locale,
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // FallbackLocalizationDelegate is not const; remove const if its ctor isn't const.
          ],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: SafeArea(top: false, child: child!),
          ),
          supportedLocales: locals,
          home: SplashScreen(body: body),
        );
      },
    );
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}

// Dev-only: bypass bad certs. Remove for production.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? c) {
    return super.createHttpClient(c)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
