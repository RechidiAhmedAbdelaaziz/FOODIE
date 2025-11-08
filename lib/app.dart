import 'package:app/core/localization/localization_cubit.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/locator.dart';
import 'core/localization/app_localization.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) {
        return BlocProvider(
          create: (context) => locator<LocalizationCubit>(),
          child: _MaterialApp(),
        );
      },
    );
  }
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp();

  @override
  Widget build(BuildContext context) {
    final router = locator<AppRouter>();

    final local = context.watch<LocalizationCubit>().state;

    return MaterialApp.router(
      routerConfig: router.router,
      theme: AppThemes.theme,
      supportedLocales: [
        Locale('en'), // English
        Locale('fr'), // French
        Locale('ar'), // Arabic
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: local,
      localeResolutionCallback: (locale, supportedLocales) {
        final langCode = supportedLocales
            .firstWhere(
              (l) => l.languageCode == locale?.languageCode,
              orElse: () => supportedLocales.first,
            )
            .languageCode;

        context.read<LocalizationCubit>().init(langCode);
        return null;
      },
    );
  }
}
