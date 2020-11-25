import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordState createState() => RandomWordState();
}

class RandomWordState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int item) {
          if(item.isOdd) return Divider();

          final index = item ~/ 2;

          if(index  >= _randomWordPairs.length) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_randomWordPairs[index]);

        }
    );
  }

  Widget _buildRow(WordPair wordPair) {
    final alreadySaved = _savedWordPairs.contains(wordPair);
    return ListTile(
        title: Text(
          wordPair.asPascalCase,
          style: TextStyle(
              fontSize: 18.0
          ),
        ),
      trailing: Icon(
        alreadySaved ? Icons.favorite: Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
          setState(() {
            if(alreadySaved) {
              _savedWordPairs.remove(wordPair);
            } else {
              _savedWordPairs.add(wordPair);
            }
          });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext buildContext) {
            final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair wordPair) {
              return ListTile(
                title: Text(
                  wordPair.asPascalCase,
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                ),
              );
            });

            final List<Widget> divided = ListTile.divideTiles(
              context: buildContext,
              tiles: tiles,
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('Saved Word Pairs'),
              ),
              body: ListView(
                children: divided,
              )
            );
          }


      )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Pair Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            onPressed: () {
              _pushSaved();
            },

          )
        ],
      ),
      body: _buildList(),
    );
  }

}