import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference getUsersCollection() {
  return FirebaseFirestore.instance.collection('users');
}

class AddUser extends StatelessWidget {
  final String name;
  final int age;

  AddUser(this.name, this.age);

  @override
  Widget build(BuildContext context) {
    Future<void> _addUser() {
      final users = getUsersCollection();
      return users
        .add({
          'name': name,
          'age': age,
        })
        .then((result) => print("User added $result"))
        .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(onPressed: _addUser, child: Text("Add User"));
  }
}

class UserList extends StatelessWidget {
  Widget build(BuildContext context) {
    Future<QuerySnapshot> _getUsers() {
      final users = getUsersCollection();
      return users.get();
    }

    return FutureBuilder(
      future: _getUsers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Failed to get user list: ${snapshot.error}');
        }

        if (snapshot.hasData) {
          final List userList = snapshot.data!.docs.toList();
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(userList[index]["name"]);
            }
          );
        } else {
          return Text('no data');
        }
      },
    );
  }
}
