import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/model/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoLoaded(todos: [], selectedDate: null)) {
    on<TodoEventAdd>((event, emit) {
      final currentState = state;
      if (currentState is TodoLoaded) {
        final List<Todo> updatedTodos = List.from(currentState.todos);
        updatedTodos.add(
          Todo(tittle: event.title, isComplete: false, date: event.date),
        );
        emit(
          TodoLoaded(
            todos: updatedTodos,
            selectedDate: currentState.selectedDate,
          ),
        );
      }
    });

    on<TodoSelectDate>((event, emit) {
      final currentState = state;
      if (currentState is TodoLoaded) {
        emit(TodoLoaded(todos: currentState.todos, selectedDate: event.date));
      }
    });

    on<TodoEventComplete>((event, emit) {
      final currentState = state;
      if (currentState is TodoLoaded) {
        final List<Todo> updatedTodos = List.from(currentState.todos);
        if (event.index >= 0 && event.index < updatedTodos.length) {
          updatedTodos[event.index] = Todo(
            tittle: updatedTodos[event.index].tittle,
            isComplete: !updatedTodos[event.index].isComplete,
            date: updatedTodos[event.index].date,
          );
          emit(
            TodoLoaded(
              todos: updatedTodos,
              selectedDate: currentState.selectedDate,
            ),
          );
        }
      }
    });
  }
}

