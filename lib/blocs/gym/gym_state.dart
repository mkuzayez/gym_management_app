import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum GymStatus { initial, loading, success, failure }

class GymState extends Equatable {
  final GymStatus status;
  final List<dynamic> gyms;
  final String? errorMessage;

  const GymState({
    this.status = GymStatus.initial,
    this.gyms = const [],
    this.errorMessage,
  });

  GymState copyWith({
    GymStatus? status,
    List<dynamic>? gyms,
    String? errorMessage,
  }) {
    return GymState(
      status: status ?? this.status,
      gyms: gyms ?? this.gyms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, gyms, errorMessage];
}
