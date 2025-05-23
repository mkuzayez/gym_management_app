enum AppStatus { initial, loading, success, failure }

abstract class AppState {
  final AppStatus status;
  
  const AppState({required this.status});
  
  AppState copyWith({AppStatus? status});
}
