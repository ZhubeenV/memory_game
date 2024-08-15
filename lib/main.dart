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
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int horCards = 4; // Number of cards horizontally
  int vertCards = 4; // Number of cards vertically
  late List<List<int>> matrix;
  bool freeze = false;
  List<int>? firstCard; // Store the position of the first card clicked
  late List<List<bool>> flippedCards; // Track which cards are flipped
  late List<List<bool>> matchedCards; // Track which cards have been matched
  int found = 0;
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    // Generate card pairs and shuffle
    List<int> ar = List<int>.generate(horCards * vertCards ~/ 2, (i) => i)..addAll(List<int>.generate(horCards * vertCards ~/ 2, (i) => i));
    ar.shuffle();

    // Create the matrix
    matrix = List.generate(horCards, (i) => List.generate(vertCards, (j) => ar[i * vertCards + j]));
    
    // Initialize flipped cards and matched cards to false
    flippedCards = List.generate(horCards, (_) => List.generate(vertCards, (_) => false));
    matchedCards = List.generate(horCards, (_) => List.generate(vertCards, (_) => false));
    
    startTime = DateTime.now();
  }

  void flipCard(int x, int y) {
    if (!freeze && !flippedCards[x][y] && !matchedCards[x][y]) {
      setState(() {
        flippedCards[x][y] = true;
      });

      if (firstCard == null) {
        // First card flipped
        firstCard = [x, y];
      } else {
        // Second card flipped, check for match
        freeze = true;
        Future.delayed(Duration(seconds: 2), () {
          if (matrix[x][y] == matrix[firstCard![0]][firstCard![1]]) {
            // Cards match, mark them as matched
            setState(() {
              matchedCards[x][y] = true;
              matchedCards[firstCard![0]][firstCard![1]] = true;
            });
            found += 2;
          } else {
            // Cards don't match, flip them back over
            setState(() {
              flippedCards[x][y] = false;
              flippedCards[firstCard![0]][firstCard![1]] = false;
            });
          }
          // Reset the first card
          firstCard = null;
          freeze = false;

          if (found == horCards * vertCards) {
            Duration finalTime = DateTime.now().difference(startTime);
            print("Final time: ${finalTime.inSeconds} seconds");
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: vertCards,
        ),
        itemCount: horCards * vertCards,
        itemBuilder: (context, index) {
          int x = index ~/ vertCards;
          int y = index % vertCards;
          return GestureDetector(
            onTap: () => flipCard(x, y),
            child: matchedCards[x][y]
                ? Container() // Hide the matched card completely
                : Card(
                    child: Center(
                      child: Text(flippedCards[x][y] ? matrix[x][y].toString() : ''),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
