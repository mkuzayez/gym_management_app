import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/blocs/member/member_bloc.dart';
import 'package:gym_management_app/blocs/member/member_event.dart';
import 'package:gym_management_app/blocs/member/member_state.dart';
import 'package:gym_management_app/models/member.dart';
import 'package:gym_management_app/screens/member_detail_screen.dart';

class MemberListScreen extends StatelessWidget {
  const MemberListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MemberDetailScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<MemberBloc, MemberState>(
        listener: (context, state) {
          if (state is MemberOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is MemberError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MemberLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MembersLoaded) {
            if (state.members.isEmpty) {
              return const Center(child: Text('No members found. Add one!'));
            }
            return ListView.builder(
              itemCount: state.members.length,
              itemBuilder: (context, index) {
                final member = state.members[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Phone: ${member.phoneNumber}'),
                        Text('Email: ${member.email}'),
                        Text('In Gym: ${member.isInGym ? 'Yes' : 'No'}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MemberDetailScreen(member: member),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                context.read<MemberBloc>().add(DeleteMember(id: member.id));
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (member.isInGym) {
                                  context.read<MemberBloc>().add(RecordMemberExit(id: member.id));
                                } else {
                                  context.read<MemberBloc>().add(RecordMemberEntry(id: member.id));
                                }
                              },
                              child: Text(member.isInGym ? 'Record Exit' : 'Record Entry'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is MemberError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Press the + button to add a member.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MemberBloc>().add(LoadMembers());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}