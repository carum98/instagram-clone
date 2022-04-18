import 'package:flutter/material.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/provider/post_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      hintStyle: const TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder<List<PostModel>>(
              stream: context.read<PostProvider>().postsStream,
              initialData: context.read<PostProvider>().posts,
              builder: (context, snapshot) {
                final posts = snapshot.data!;

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => Image(
                      image: NetworkImage(posts[index].imageUrl),
                      fit: BoxFit.cover,
                    ),
                    childCount: posts.length,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
