import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'components/controllers/product_controllers.dart';
import 'components/controllers/user_controllers.dart';
import 'components/preferences/user.dart';
import 'components/screens/dashboard/product_screen.dart';
import 'components/screens/splash_screen/splash_screen.dart';
 
void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  await initLocalStorage();
  await Supabase.initialize(
    url: 'https://yhvagkgcvehcbsexctmh.supabase.co',
    anonKey: ''
  );

  runApp(MyApp(userPreferences: UserPreferences()));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  final UserPreferences userPreferences;

  const MyApp({super.key, required this.userPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserController()),
        ChangeNotifierProvider(create: (context) => ProductController()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
          future: UserPreferences.getUserLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              final bool isLoggedIn = snapshot.data ?? false;
              return isLoggedIn ? const ProductScreen() : const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
