import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'themes/app_theme.dart';
import 'routes/app_routes.dart';
import 'services/navigation_service.dart';
import 'services/game_sound_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/bingo_game/bingo_game_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/auth/auth_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/auth/auth_event.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/app/flavor_config.dart';
import 'package:hiphop_rnb_bingo/app/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Configure app flavor
  final config = AppFlavorConfig(
    name: 'production',
    apiBaseUrl: dotenv.env['API_BASE_URL'] ?? '',
    webUrl: dotenv.env['WEB_URL'] ?? '',
    mixpanelToken: dotenv.env['MIXPANEL_TOKEN'] ?? '',
  );

  // Setup service locator
  await setupLocator(config);

  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize sound service
  final gameSoundService = GameSoundService();
  await gameSoundService.initialize();

  // Check vibration availability with debug logging
  bool canVibrate = await gameSoundService.checkVibrationAvailability();
  if (kDebugMode) {
    print('Vibration availability: $canVibrate');
    print('Using API URL: ${dotenv.env['API_BASE_URL']}');
    print('Using Web URL: ${dotenv.env['WEB_URL']}');
  }

  // Create auth bloc and check authentication status
  final authBloc = AuthBloc();
  authBloc.add(CheckAuthStatus());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BalanceBloc()),
        BlocProvider(create: (context) => BingoGameBloc()),
        BlocProvider(create: (context) => authBloc),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Base design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Initialize AppDimension after ScreenUtil
        AppDimension.init(context);

        return MaterialApp(
          title: 'HIPHOP & RNB BINGO',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          navigatorKey: NavigationService.navigatorKey,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
          builder: (context, widget) {
            // Initialize AppDimension for each screen
            AppDimension.init(context);
            return MediaQuery(
              // Prevent system text scaling from affecting our app
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
