abstract class CuratorState {}

class CuratorInitial extends CuratorState {}

class CuratorLoading extends CuratorState {}

class CuratorLoaded extends CuratorState {
  final List items; // Nanti diisi dengan List<CuratorItem>
  CuratorLoaded({required this.items});
}

class CuratorError extends CuratorState {
  final String message;
  CuratorError({required this.message});
}