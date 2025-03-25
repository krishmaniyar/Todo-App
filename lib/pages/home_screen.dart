import 'package:flutter/material.dart';
import 'package:todo_app/model/authentication.dart';
import 'package:todo_app/pages/login_screen.dart';
import 'package:todo_app/model/database_service.dart';
import 'package:todo_app/widgets/complete_widget.dart';
import 'package:todo_app/widgets/pending_widget.dart';

import '../model/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _buttonIndex = 0;

  final _widgets = [
    PendingWidget(),
    CompleteWidget(),
  ];

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blue,Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hi,',
                        style: TextStyle(
                          fontSize: 33.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'PlayFair',
                        ),
                      ),
                      IconButton(
                        onPressed: ()async {
                          await AuthService().signOut();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                          size: 33,
                        )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: StreamBuilder(
                    stream: _databaseService.info,
                    builder: (context, snapshot) {
                      return Text(
                        '${snapshot.data}',
                        style: TextStyle(
                          fontSize: 50,
                          letterSpacing: 4,
                          color: Colors.grey[900],
                          fontWeight: FontWeight.w900,
                          fontFamily: 'PlayFair',
                        ),
                      );
                    },
                  ),
                ),
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
                          color: _buttonIndex == 0 ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Pending",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'PlayFair',
                              color: _buttonIndex == 0 ? Colors.black : Colors.black54,
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
                          color: _buttonIndex == 1 ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Complete",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'PlayFair',
                              color: _buttonIndex == 1 ? Colors.black : Colors.black54,
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 28,
        ),
        onPressed: () {
          _showTaskDialog(context);
        }
      ),
    );
  }

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
          fontWeight: FontWeight.w700,
          fontFamily: 'PlayFair',
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextField(
                controller: _titleControlller,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PlayWrite',
                ),
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _descriptionControlller,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PlayWrite',
                ),
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
              "Cancel",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                fontFamily: 'PlayFair',
              ),
            )
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
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
              style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              fontFamily: 'PlayFair',
              ),
            )
        )
      ],
    );
  });
}
