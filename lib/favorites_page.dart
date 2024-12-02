import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesBox = Hive.box('favoritesBox');

    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: ValueListenableBuilder(
        valueListenable: favoritesBox.listenable(),
        builder: (context, Box box, _) {
          final favorites = box.values.toList();

          if (favorites.isEmpty) {
            return Center(child: Text('No Favorites Yet'));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(favorites[index]),
                // Add more details or actions as needed
              );
            },
          );
        },
      ),
    );
  }
}