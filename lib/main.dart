import 'package:first_task_app/frontend/navigation/index.dart';
import 'package:get/get.dart';
 
void main() async {
  // 1. Mandatory for async code in main
  WidgetsFlutterBinding.ensureInitialized();
  
  final authService = AuthService();
  
  // 2. Check if token exists in FlutterSecureStorage
  final bool loggedIn = await authService.isLoggedIn();

  // 3. Optional: Verify token validity by calling getProfile() 
  // if you want to be extra safe before showing the home screen.

  runApp(MyApp(initialRoute: loggedIn ? Routes.home : Routes.welcome));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First Task App',
      initialRoute: initialRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}