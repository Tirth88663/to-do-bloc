abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String task;
  AddTodo(this.task);
}

class ToggleTodo extends TodoEvent {
  final int index;
  ToggleTodo(this.index);
}
