import 'package:app_fitmanagerpro/Src/Features/auth/controller/login_controller.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/controller/register_controller.dart';
import 'package:get_it/get_it.dart';

import 'package:app_fitmanagerpro/Src/Db/http_manager..dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_api.dart';
import 'package:app_fitmanagerpro/Src/Features/auth/data/auth_session.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Core
  sl.registerLazySingleton<HttpManager>(() => HttpManager());
  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<HttpManager>()));
  sl.registerLazySingleton<AuthSession>(() => AuthSession());

  // Controllers
  sl.registerFactory<LoginController>(
    () => LoginController(api: sl<AuthApi>(), session: sl<AuthSession>()),
  );

  sl.registerFactory<RegisterController>(
    () => RegisterController(api: sl<AuthApi>(), session: sl<AuthSession>()),
  );
}
