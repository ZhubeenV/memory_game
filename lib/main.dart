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
  int horCards = 4; // Adjust based on your game setup
  int vertCards = 4; // Adjust based on your game setup
  late List<List<int>> matrix;
  bool freeze = false;
  List<dynamic> pressed = [];
  int step = 0;
  int found = 0;
  late DateTime startTime;
  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    List<int> ar = List<int>.generate(horCards * vertCards ~/ 2, (i) => i)..addAll(List<int>.generate(horCards * vertCards ~/ 2, (i) => i));
    ar.shuffle();
    matrix = List.generate(horCards, (i) => List.generate(vertCards, (j) => ar[i * vertCards + j]));
    startTime = DateTime.now();
  }

  void doSomething(int a, int b) {
    if (!freeze) {
      setState(() {
        freeze = true;
        if (step == 0) {
          pressed = [a, b];
          freeze = false;
        } else {
          Future.delayed(Duration(seconds: 1), () {
            if (matrix[a][b] == matrix[pressed[0]][pressed[1]]) {
              // Update logic to "remove" or mark as found
              found += 2;
            }
            // Reset or update UI based on game logic
            setState(() {
              freeze = false;
            });

            if (found == horCards * vertCards) {
              Duration finalTime = DateTime.now().difference(startTime);
              print("Final time: ${finalTime.inSeconds} seconds");
            }
          });
        }
        step = 1 - step;
      });
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
            onTap: () => doSomething(x, y),
            child: Card(
              child: Center(child: Text(freeze ? matrix[x][y].toString() : '')),
            ),
          );
        },
      ),
    );
  }
}

// class _MemoryGamePageState extends State<MemoryGamePage> {
//   // Game state variables and logic will be here

//   @override
//   Widget build(BuildContext context) {
//     // Build your game's UI here
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Memory Game'),
//       ),
//       body: GridView.builder(
//         itemCount: 30, // Number of cards
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 5, // Number of cards in a row
//         ), 
//         itemBuilder: (context, index) {
//           // Build your card widgets here
//         },  
//         // Build your grid of cards here
//       ),
//     );
//   }
// }

// class CardModel {
//   String imageUrl;
//   bool isFlipped = false;
//   bool isMatched = false;

//   CardModel(this.imageUrl);
// }

// GridView buildGrid() {
//   // You'll need to initialize a list of cards and implement game logic
//   return GridView.builder(
//     itemCount: 30, // Number of cards
//     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 5, // Number of cards in a row
//     ),
//     itemBuilder: (context, index) {
//       // Build your card widgets here
//     },
//   );
// }
