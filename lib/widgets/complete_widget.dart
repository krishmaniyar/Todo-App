import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/database_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../model/todo_model.dart';

class CompleteWidget extends StatefulWidget {
  const CompleteWidget({super.key});

  @override
  State<CompleteWidget> createState() => _CompleteWidgetState();
}

class _CompleteWidgetState extends State<CompleteWidget> {

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
        stream: _databaseService.completedTodos,
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
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Slidable(
                      key: ValueKey(todo.id),
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
                          )
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
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(height: 3), // Adjust the height as needed
                              Text(
                                todo.description,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'PlayWrite',
                                  decoration: TextDecoration.lineThrough,
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
}
