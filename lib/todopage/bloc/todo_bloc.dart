import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todos = prefs.getStringList('todos');
    List<String>? statuses = prefs.getStringList('statuses');

    List<Map<String, dynamic>> todoList = [];
    if (todos != null && statuses != null) {
      for (int i = 0; i < todos.length; i++) {
        todoList.add({'task': todos[i], 'completed': statuses[i] == 'true'});
      }
    }
    emit(TodoState(todos: todoList));
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    final newTodo = {'task': event.task, 'completed': false};
    final updatedTodos = List<Map<String, dynamic>>.from(state.todos)
      ..add(newTodo);

    updatedTodos.sort((a, b) => a['completed'] ? 1 : -1);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'todos', updatedTodos.map((e) => e['task'].toString()).toList());
    prefs.setStringList('statuses',
        updatedTodos.map((e) => e['completed'].toString()).toList());

    emit(TodoState(todos: updatedTodos));
  }

  Future<void> _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    final updatedTodos = List<Map<String, dynamic>>.from(state.todos);
    final todo = updatedTodos.removeAt(event.index);

    todo['completed'] = !todo['completed'];

    updatedTodos.add(todo);
    updatedTodos.sort((a, b) => a['completed'] ? 1 : -1);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'todos', updatedTodos.map((e) => e['task'].toString()).toList());
    prefs.setStringList('statuses',
        updatedTodos.map((e) => e['completed'].toString()).toList());

    emit(TodoState(todos: updatedTodos));
  }
}
