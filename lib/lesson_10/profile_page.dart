import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing_lab/lesson_08/profile_cubit.dart';
import 'package:flutter_testing_lab/lesson_08/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const new({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => switch (state) {
          ProfileInitial() ||
          ProfileLoading() => const Center(child: CircularProgressIndicator()),
          ProfileLoaded(:final name) => Center(child: Text('Hello, $name')),
          ProfileError(:final message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => context.read<ProfileCubit>().load(),
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        },
      ),
    );
  }
}
