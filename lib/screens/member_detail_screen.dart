import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/blocs/member/member_bloc.dart';
import 'package:gym_management_app/blocs/member/member_event.dart';
import 'package:gym_management_app/blocs/member/member_state.dart';
import 'package:gym_management_app/models/member.dart';

class MemberDetailScreen extends StatefulWidget {
  final Member? member; // Null for adding, not null for editing

  const MemberDetailScreen({super.key, this.member});

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late bool _isInGym;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController(text: widget.member?.phoneNumber ?? '');
    _passwordController = TextEditingController(); // Password is not pre-filled for security
    _nameController = TextEditingController(text: widget.member?.name ?? '');
    _emailController = TextEditingController(text: widget.member?.email ?? '');
    _isInGym = widget.member?.isInGym ?? false;
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.member == null) {
        // Add new member
        context.read<MemberBloc>().add(
              AddMember(
                phoneNumber: _phoneNumberController.text,
                password: _passwordController.text,
                name: _nameController.text,
                email: _emailController.text,
              ),
            );
      } else {
        // Update existing member
        context.read<MemberBloc>().add(
              UpdateMember(
                id: widget.member!.id,
                phoneNumber: _phoneNumberController.text,
                name: _nameController.text,
                email: _emailController.text,
                isInGym: _isInGym,
              ),
            );
      }
      Navigator.of(context).pop(); // Go back after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.member == null ? 'Add New Member' : 'Edit Member'),
      ),
      body: BlocListener<MemberBloc, MemberState>(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                if (widget.member == null) // Only show password for new member
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (widget.member == null && (value == null || value.isEmpty)) {
                        return 'Please enter a password for new member';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16.0),
                if (widget.member != null) // Only show isInGym for existing member
                  SwitchListTile(
                    title: const Text('Is in Gym'),
                    value: _isInGym,
                    onChanged: (bool value) {
                      setState(() {
                        _isInGym = value;
                      });
                    },
                  ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.member == null ? 'Add Member' : 'Update Member'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}