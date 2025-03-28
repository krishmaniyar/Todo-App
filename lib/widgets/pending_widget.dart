import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/database_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../model/todo_model.dart';

class PendingWidget extends StatefulWidget {
  const PendingWidget({super.key});

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget> {

  User? user = FirebaseAuth.instance.currentUser;
  late String uid;

  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: _databaseService.todos,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List<Todo> todos = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index];
              final DateTime dt = todo.timestamp.toDate();
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                  key: ValueKey(todo.id),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.check,
                          label: "Mark",
                        onPressed: (context) {
                          _databaseService.updateTodoStatus(todo.id, true);
                        }
                      )
                    ]
                  ),
                  startActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: "Delete",
                        onPressed: (context) async{
                          await _databaseService.deleteTodoTask(todo.id);
                        }
                      ),
                      SlidableAction(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: "Edit",
                        onPressed: (context) {
                          _showTaskDialog(context, todo: todo);
                        }
                      ),
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'PlayWrite',
                            ),
                          ),
                          SizedBox(height: 3), // Adjust the height as needed
                          Text(
                            todo.description,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PlayWrite',
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        "${dt.day}/${dt.month}/${dt.year}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'PlayWrite',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(color: Colors.white,),
          );
        }
      }
    );
  }

  void _showTaskDialog(BuildContext context, {Todo? todo}) {
    final TextEditingController _titleControlller = TextEditingController(
        text: todo?.title);
    final TextEditingController _descriptionControlller = TextEditingController(
        text: todo?.description);
    final DatabaseService _databaseService = DatabaseService();

    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          todo == null ? "Add Task" : "Edit Task",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              children: [
                TextField(
                  controller: _titleControlller,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: _descriptionControlller,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                  "Cancel"
              )
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (todo == null) {
                  await _databaseService.addTodoItem(
                      _titleControlller.text, _descriptionControlller.text);
                }
                else {
                  await _databaseService.updateTodo(
                      todo.id, _titleControlller.text,
                      _descriptionControlller.text);
                }
                Navigator.pop(context);
              },
              child: Text(
                todo == null ? "Add" : "Update",
              )
          )
        ],
      );
    });
  }
}
