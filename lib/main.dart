import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_planner/services/navigation_service.dart';

import 'common/constants.dart';
import 'common/providers.dart';
import 'common/routes.dart';
import 'common/themes.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'modules/main/main_module.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PlannerApp());
}

class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: R.appName,
        theme: theme,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
          // return supportedLocales.last;
        },
        routes: routes,
        initialRoute: MainModule.route,
        navigatorKey: NavigationService().navigatorKey,
      ),
    );
  }
}
