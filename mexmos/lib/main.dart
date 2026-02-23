import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/constants.dart';
import 'logic/configurador_logic.dart';
import 'logic/carrito_logic.dart';
import 'ui/screens/catalogo_screen.dart';
import 'ui/screens/configurador_screen.dart';
import 'ui/screens/resumen_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Raíz de la aplicación que inyecta los Providers en el árbol de widgets.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfiguradorLogic()),
        ChangeNotifierProvider(create: (_) => CarritoLogic()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const CatalogoScreen(),
          '/configurador': (context) => const ConfiguradorScreen(),
          '/resumen': (context) => const ResumenScreen(),
        },
      ),
    );
  }
}