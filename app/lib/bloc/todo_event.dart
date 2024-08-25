part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();
}

final class ListTodos extends TodoEvent {
  final Map<String, Todo> todos;

  const ListTodos(this.todos);

  @override
  List<Object> get props => [todos];
}

final class CreateTodo extends TodoEvent {
  final Todo todo;

  const CreateTodo(this.todo);

  @override
  List<Object> get props => [todo];
}

final class DeleteTodo extends TodoEvent {
  final Todo todo;

  const DeleteTodo(this.todo);

  @override
  List<Object> get props => [todo];
}

final class UpdateTodo extends TodoEvent {
  final Todo todo;

  const UpdateTodo(this.todo);

  @override
  List<Object> get props => [todo];
}
