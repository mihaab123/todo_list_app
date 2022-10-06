import 'package:get_it/get_it.dart';
import 'package:todo_list_app/services/hive_storage_service.dart';
import 'package:todo_list_app/services/storage_service.dart';

final getIt = GetIt.I;

void setUpServiceLocator() {
  getIt.registerSingleton<StorageService>(HiveStorageService());
}
