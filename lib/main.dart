import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicknotes/app/colors.dart';
import 'package:quicknotes/app/locator.dart';
import 'package:quicknotes/app/snackbar_ui.dart';
import 'package:quicknotes/services/storage_service.dart';
import 'package:quicknotes/ui/views/confirmation/confirmation_view.dart';
import 'package:quicknotes/ui/views/home/home_view.dart';
import 'package:quicknotes/ui/views/note/note_view.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.router.dart';
import 'ui/views/authentication/authentication_view.dart';
import 'ui/views/commit/commit_view.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupSnackbarUi();
  await Firebase.initializeApp();
  await locator<StorageService>().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF2F3763),
        appBarTheme: AppBarTheme(elevation: 2, color: AppColors.green),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          backgroundColor: AppColors.green,
          largeSizeConstraints: BoxConstraints(
              maxWidth: 71, maxHeight: 71, minHeight: 70, minWidth: 70),
        ),
        textTheme: const TextTheme(
            bodyText1: TextStyle(color: Color(0xFF819DAD), fontSize: 20)),
      ),
      //home: HomeView(),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
