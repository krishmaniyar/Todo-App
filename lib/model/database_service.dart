import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'todo_model.dart';

class DatabaseService {
  final CollectionReference todoCollection = FirebaseFirestore.instance.collection('todos');
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference userInfo = FirebaseFirestore.instance.collection('user');


  Future<DocumentReference> addTodoItem(String title, String description) async{
    return await todoCollection.add({
      'uid' : user!.uid,
      'title' : title,
      'description' : description,
      'completed' : false,
      'createdAt' : FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTodo(String id, String title, String description) async{
    final updatetodoCollection = FirebaseFirestore.instance.collection('todos').doc(id);
    return await updatetodoCollection.update({
      'title' : title,
      'description' : description,
    });
  }

  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({
      'completed' : completed,
    });
  }

  Future<void> deleteTodoTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  Stream<List<Todo>> get todos {
    return todoCollection.where('uid', isEqualTo: user!.uid).where('completed', isEqualTo: false).snapshots().map(_todoListFromSnapshot);
  }

  Stream<List<Todo>> get completedTodos {
    return todoCollection.where('uid', isEqualTo: user!.uid).where('completed', isEqualTo: true).snapshots().map(_todoListFromSnapshot);
  }

  Stream get info {
    return userInfo
        .where('uid', isEqualTo: user!.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first['username'];
      } else {
        return '';
      }
    });
  }

  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Todo(id: doc.id,
          title: doc['title'] ?? "",
          description: doc['description'] ?? "",
          completed: doc['completed'] ?? false,
          timestamp: doc['createdAt'] ?? "",
      );
    }).toList();
  }
}