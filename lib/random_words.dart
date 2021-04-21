import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordsList = <WordPair>[];
  final _savedWordPair = Set<WordPair>();

  Widget _buildRow(WordPair word) {
    final saved = _savedWordPair.contains(word);
    return ListTile(
      title: Text(
        word.asPascalCase,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(saved ? Icons.favorite : Icons.favorite_border,
          color: saved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (saved) {
            _savedWordPair.remove(word);
          } else {
            _savedWordPair.add(word);
          }
        });
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider();
        final itemIndex = index ~/ 2;
        if (itemIndex >= _randomWordsList.length) {
          _randomWordsList.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_randomWordsList[itemIndex]);
      },
    );
  }

  void _onPressedIcon() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordPair.map((WordPair item) {
        return ListTile(
            title: Text(item.asPascalCase, style: TextStyle(fontSize: 18.0)));
      });

      final List<Widget> divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();

      return Scaffold(
        appBar: AppBar(title: Text('Saved Words')),
        body: ListView(children: divided),
      );
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Word'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _onPressedIcon)
          ],
        ),
        body: _buildList());
  }
}
