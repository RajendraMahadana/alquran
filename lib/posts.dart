import 'package:flutter/material.dart';
import 'http_service.dart';
import 'post_model.dart';
import 'package:audioplayers/audioplayers.dart';

class PostsPage extends StatelessWidget {
  final HttpService httpService = HttpService();
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Al-Quran")),
      body: FutureBuilder<List<Post>>(
        future: httpService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final posts = snapshot.data ?? [];
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.nama),
                subtitle: Text(post.nama_latin),
                trailing: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () async {
                    if (post.audio.isNotEmpty) {
                      await audioPlayer.play(UrlSource(post.audio));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}