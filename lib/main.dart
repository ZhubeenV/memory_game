import 'package:flutter/material.dart';

void main() => runApp(MemoryGameApp());

class MemoryGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoryGamePage(),
    );
  }
}

class MemoryGamePage extends StatefulWidget {
  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  // Game state variables and logic will be here

  @override
  Widget build(BuildContext context) {
    // Build your game's UI here
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: GridView.builder(
        itemCount: 30, // Number of cards
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // Number of cards in a row
        ), 
        itemBuilder: (context, index) {
          // Build your card widgets here
        },  
        // Build your grid of cards here
      ),
    );
  }
}

class CardModel {
  String imageUrl;
  bool isFlipped = false;
  bool isMatched = false;

  CardModel(this.imageUrl);
}

GridView buildGrid() {
  // You'll need to initialize a list of cards and implement game logic
  return GridView.builder(
    itemCount: 30, // Number of cards
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 5, // Number of cards in a row
    ),
    itemBuilder: (context, index) {
      // Build your card widgets here
    },
  );
}
