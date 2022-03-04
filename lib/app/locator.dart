import 'package:get_it/get_it.dart';
import 'package:quicknotes/services/app_firebase_service.dart';
import 'package:quicknotes/services/misc_service.dart';
import 'package:quicknotes/services/storage_service.dart';
import 'package:stacked_services/stacked_services.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppFirebaseService());
  locator.registerLazySingleton(() => MiscService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
}
