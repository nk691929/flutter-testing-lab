import 'package:bloc/bloc.dart';
import 'package:flutter_testing_lab/lesson_07/profile_repository.dart';

import 'package:flutter_testing_lab/lesson_08/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileInitial());
  final ProfileRepository _repository;

  Future<void> load() async {
    emit(const ProfileLoading());
    try {
      final name = await _repository.getUserName();
      emit(ProfileLoaded(name));
    } on Exception {
      emit(const ProfileError('Could not load profile'));
    }
  }
}
