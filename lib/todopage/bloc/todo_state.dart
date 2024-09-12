class TodoState {
  List<Map<String, dynamic>> todos;
  TodoState({required this.todos});
}

class TodoInitial extends TodoState {
  TodoInitial() : super(todos: []);
}
