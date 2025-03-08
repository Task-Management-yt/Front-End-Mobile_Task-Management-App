import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/providers/task_provider.dart';
import 'package:task_management_app/views/welcome_view.dart';
import 'views/home_view.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, TaskProvider>(
          create:
              (context) => TaskProvider(
                Provider.of<AuthProvider>(context, listen: false),
              ),
          update:
              (context, authProvider, previous) => TaskProvider(authProvider),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      home: authProvider.isAuthenticated ? HomeView() : WelcomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
