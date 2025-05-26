import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/blocs/auth/auth_bloc.dart';
import 'package:gym_management_app/blocs/auth/auth_event.dart';
import 'package:gym_management_app/blocs/auth/auth_state.dart';
import 'package:gym_management_app/repositories/auth_repository.dart';
import 'package:gym_management_app/screens/auth/login_screen.dart';
import 'package:gym_management_app/screens/home_screen.dart';
import 'package:gym_management_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        )..add(AppStarted()), // Dispatch AppStarted event when the app starts
        child: MaterialApp(
          title: 'Gym Management App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const HomeScreen();
              } else if (state is AuthUnauthenticated) {
                return LoginScreen();
              } else if (state is AuthLoading || state is AuthInitial) {
                return const SplashScreen(); // Show splash screen while checking auth status
              }
              return const Center(child: Text('Unknown State')); // Should not happen
            },
          ),
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}