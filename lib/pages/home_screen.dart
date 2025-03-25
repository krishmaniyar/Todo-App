import 'package:flutter/material.dart';
import 'package:todo_app/model/authentication.dart';
import 'package:todo_app/pages/login_screen.dart';
import 'package:todo_app/services/database_service.dart';

import '../model/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _buttonIndex = 0;

  final _widgets = [
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1d2630),
        title: Text(
          'ToDo',
        ),
        actions: [
          IconButton(
            onPressed: ()async {
              await AuthService().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.exit_to_app)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 0 ? Colors.indigo : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          fontSize: _buttonIndex == 0 ? 16 : 14,
                          fontWeight: FontWeight.w500,
                          color: _buttonIndex == 0 ? Colors.white : Colors.black38,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 1 ? Colors.indigo : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "complete",
                        style: TextStyle(
                          fontSize: _buttonIndex == 1 ? 16 : 14,
                          fontWeight: FontWeight.w500,
                          color: _buttonIndex == 1 ? Colors.white : Colors.black38,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30,),
            _widgets[_buttonIndex],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add
        ),
        onPressed: () {
          _showTaskDialog(context);
        }
      ),
    );
  }

  void _showTaskDialog(BuildContext context, {Todo? todo}) {
    final TextEditingController _titleControlller = TextEditingController(text: todo?.title);
    final TextEditingController _descriptionControlller = TextEditingController(text: todo?.description);
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
            width: MediaQuery.of(context).size.width,
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
            onPressed: () async{
              if(todo == null) {
                await _databaseService.addTodoItem(_titleControlller.text, _descriptionControlller.text);
              }
              else {
                await _databaseService.updateTodo(todo.id, _titleControlller.text, _descriptionControlller.text);
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
