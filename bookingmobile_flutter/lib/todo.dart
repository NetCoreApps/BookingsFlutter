import 'package:flutter/material.dart';
import 'package:servicestack/servicestack.dart';

import 'dtos.dart';
import 'main.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StatefulWidget> createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  //State for this widget

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshTodos();
    });
  }

  Future<QueryResponse<Todo>> queryTodos() {
    return BookingMobile.getClient().get(QueryTodos());
  }

  Future<Todo> updateTodo(Todo item) {
    return BookingMobile.getClient().put(UpdateTodo(
        id: item.id,
        isFinished: (item.isFinished ?? false) ? true : false,
        text: item.text));
  }

  Future<void> refreshTodos() {
    return queryTodos().then((val) => {
          setState(() => {todos = val.results ?? <Todo>[]})
        });
  }

  Future<void> deleteTodo(Todo item) {
    return BookingMobile.getClient().delete(DeleteTodo(id: item.id));
  }

  Future<Todo> createTodo(String text) {
    return BookingMobile.getClient().post(CreateTodo(
      text: text
    ));
  }

  List<Todo> todos = <Todo>[];
  var todoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'What needs to be done?',
                  ),
                  onSubmitted: (value) => {
                    createTodo(value).then((val) => {
                      refreshTodos(),
                      todoTextController.value = TextEditingValue.empty
                    })
                  },
                  controller: todoTextController,
                ),
              ),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        title: Row(
                          children: [
                            Text(
                              todos[index].text ?? "",
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              alignment: Alignment.centerRight,
                                onPressed: () => {
                                      deleteTodo(todos[index])
                                          .then((val) => {refreshTodos()})
                                    },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                        value: todos[index].isFinished ?? false,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (val) {
                          todos[index].isFinished = val;
                          updateTodo(todos[index]).then((val) => {
                                setState(() {
                                  todos[index] = val;
                                })
                              });
                        });
                  })
            ],
          ),
        ));
  }
}
