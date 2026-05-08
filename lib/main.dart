import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/constants/colors.dart';
import 'presentation/screens/splash_screen.dart';
import 'blocs/curator/curator_bloc.dart';
import 'blocs/curator/curator_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const CuratorApp());
}

class CuratorApp extends StatelessWidget {
  const CuratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CuratorBloc()..add(LoadCuratorItems()),
      child: MaterialApp(
        title: 'CURATOR AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.obsidianBlack,
          primaryColor: AppColors.amethystGlow,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: AppColors.silverAsh, fontFamily: 'Inter'),
            titleLarge: TextStyle(color: AppColors.silverAsh, fontFamily: 'Playfair Display'),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}