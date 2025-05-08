import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    final _controller = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Todo List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),),
              SizedBox(height: 20,),
              Row(
                children: [
                  Column(
                    children: [
                      Text('Selected Date'),
                      BlocBuilder<TodoBloc, TodoState>(
                        builder: (context, state) {
                          if (state is TodoLoaded) {
                            if (state.selectedDate != null) {
                              return Text(
                                '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}',
                              );
                            }
                          }
                          return Text('No date selected');
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            context.read<TodoBloc>().add(
                              TodoSelectDate(date: selectedDate),
                            );
                          }
                        });
                      },
                      child: Text('selected Date'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Form(
                key: _key,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Todo',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter a todo';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    FilledButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          final selectedDate = context.read<TodoBloc>().state;
                          if (selectedDate is TodoLoaded) {
                            context.read<TodoBloc>().add(
                              TodoEventAdd(
                                title: _controller.text,
                                date: selectedDate.selectedDate!,
                              ),
                            );
                            _controller.clear();
                            selectedDate.selectedDate = null;
                          }
                        }
                      },
                      child: Text('Tambah'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is TodoLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is TodoLoaded) {
                      if (state.todos.isEmpty) {
                        return Center(child: Text('Todo list is Empty'));
                      }
                      return ListView.builder(
                        itemCount: state.todos.length,
                        itemBuilder: (context, index) {
                          final todo = state.todos[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      todo.tittle,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      '${todo.date.day}/${todo.date.month}/${todo.date.year}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      todo.isComplete
                                          ? 'Completed'
                                          : 'Not Completed',
                                      style: TextStyle(
                                        color:
                                            todo.isComplete
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                Checkbox(
                                  value: todo.isComplete,
                                  onChanged: (value) {
                                    context.read<TodoBloc>().add(
                                      TodoEventComplete(index: index),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No todos Available'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
