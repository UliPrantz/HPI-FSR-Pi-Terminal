import 'package:get_it/get_it.dart';

class InjectionContainer {
  // get an instance of the GetIt singleton to use for injection
  static final GetIt getIt = GetIt.I; // equal to: GetIt.instance;

  static Future<void> injectDependencies() async {
    // getIt.registerLazySingleton(
    //     () => SignInFormCubit(authFacade: getIt<FirebaseAuthFacade>()));
  }
}