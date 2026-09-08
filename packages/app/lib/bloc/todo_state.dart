part of 'todo_bloc.dart';

class TodoState extends Equatable {
  final Map<String, Todo> todos;

  const TodoState({
    required this.todos,
  });

  @override
  List<Object> get props => [todos];
}

final class TodoLoading extends TodoState {
  const TodoLoading({required super.todos});

  @override
  String toString() => 'TodoLoading';
}

final class TodoSuccess extends TodoState {
  const TodoSuccess({required super.todos});

  @override
  String toString() => 'TodoSuccess';
}

final class TodoFailure extends TodoState {
  const TodoFailure({required super.todos});

  @override
  String toString() => 'TodoFailure';
}
