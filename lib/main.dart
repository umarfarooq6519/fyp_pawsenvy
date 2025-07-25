import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:fyp_pawsenvy/firebase_options.dart';
import 'package:fyp_pawsenvy/core/services/storage.service.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/router/app.router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => StorageService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        Provider(create: (context) => DBService()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
