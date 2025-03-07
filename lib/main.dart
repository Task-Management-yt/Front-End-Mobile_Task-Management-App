import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home.dart';
import 'views/login.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();

  runApp(ChangeNotifierProvider(create: (_) => authProvider, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      home: authProvider.isAuthenticated ? HomeView() : LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
