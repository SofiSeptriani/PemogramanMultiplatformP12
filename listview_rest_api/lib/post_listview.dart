import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'post.dart';

class PostListView extends StatelessWidget {
  const PostListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _fetchPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Post> data = snapshot.data!;
          return _postListView(data, context);
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<Post>> _fetchPost() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'), 
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Widget _postListView(List<Post> data, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(
              Icons.article_outlined,
              color: Color.fromARGB(255, 255, 162, 68),
              size: 30,
            ),
            title: Text(
              data[index].title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: Text(data[index].title),
                      content: Text(data[index].body),
                      actions: [
                        TextButton(
                          child: const Text('Tutup'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
              );
            },
          ),
        );
      },
    );
  }
}