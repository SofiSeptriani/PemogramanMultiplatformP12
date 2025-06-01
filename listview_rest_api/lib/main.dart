import 'package:flutter/material.dart';
import 'post_listview.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Post',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PosListPage(),
      debugShowCheckedModeBanner: false, 
    );
  }
}

class PosListPage extends StatelessWidget {
  const PosListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Post')),
      body: const PostListView(),
    );
  }
}