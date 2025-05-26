import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/blocs/auth/auth_bloc.dart';
import 'package:gym_management_app/blocs/auth/auth_event.dart';
import 'package:gym_management_app/blocs/member/member_bloc.dart';
import 'package:gym_management_app/blocs/member/member_event.dart';
import 'package:gym_management_app/repositories/member_repository.dart';
import 'package:gym_management_app/screens/member_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Gym Management App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => MemberBloc(
                        memberRepository: MemberRepository(
                          authRepository: context.read<AuthBloc>().authRepository,
                        ),
                      )..add(LoadMembers()), // Load members when navigating to the screen
                      child: const MemberListScreen(),
                    ),
                  ),
                );
              },
              child: const Text('Manage Members'),
            ),
            const SizedBox(height: 20),
            const Text(
              'More features coming soon...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}