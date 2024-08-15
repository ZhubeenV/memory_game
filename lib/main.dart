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
    
    // Initialize flipped cards to false
    flippedCards = List.generate(horCards, (_) => List.generate(vertCards, (_) => false));
    
    startTime = DateTime.now();
  }

  void flipCard(int x, int y) {
    if (!freeze && !flippedCards[x][y]) {
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
            // Cards match, keep them flipped
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
            child: Card(
              child: Center(child: Text(flippedCards[x][y] ? matrix[x][y].toString() : '')),
            ),
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// void main() => runApp(MemoryGameApp());

// class MemoryGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Memory Game',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: GameScreen(),
//     );
//   }
// }

// class GameScreen extends StatefulWidget {
//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   int horCards = 4; // Adjust based on your game setup
//   int vertCards = 4; // Adjust based on your game setup
//   late List<List<int>> matrix;
//   bool freeze = false;
//   List<dynamic> pressed = [];
//   int step = 0;
//   int found = 0;
//   late DateTime startTime;
//   // Assuming vertCards and horCards are defined somewhere in your class
//   List<List<bool>> flippedCards;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the flippedCards matrix with all values set to false
//     flippedCards = List.generate(horCards, (_) => List.generate(vertCards, (_) => false));
//   }

//   void initializeGame() {
//     List<int> ar = List<int>.generate(horCards * vertCards ~/ 2, (i) => i)..addAll(List<int>.generate(horCards * vertCards ~/ 2, (i) => i));
//     ar.shuffle();
//     matrix = List.generate(horCards, (i) => List.generate(vertCards, (j) => ar[i * vertCards + j]));
//     startTime = DateTime.now();
//   }

// void doSomething(int a, int b) {
//   if (!freeze || !flippedCards[a][b]) { // Allow flipping if not frozen or if the card is not already flipped
//     setState(() {
//       if (step == 0) {
//         pressed = [a, b];
//         // Flip the first card immediately by updating the UI here
//         // For example, update a state that makes the card at [a, b] visible
//         flippedCards[a][b] = true; // Flip the card
//         // step = 1; // Move to the next step, waiting for the second card
//       } else {
//         freeze = true; // Freeze further actions until the current operation completes
//         Future.delayed(Duration(seconds: 1), () {
//           if (matrix[a][b] == matrix[pressed[0]][pressed[1]]) {
//             // Update logic to "remove" or mark as found
//             found += 2;
//           }
//           // Reset or update UI based on game logic
//           setState(() {
//             // Flip the second card here if not already flipped by default UI logic

//             freeze = false; // Unfreeze after operation completes
//           });

//           if (found == horCards * vertCards) {
//             Duration finalTime = DateTime.now().difference(startTime);
//             print("Final time: ${finalTime.inSeconds} seconds");
//           }
//         });
//         step = 0; // Reset step for the next pair of cards
//       }
//     });
//   }
// }

//   // void doSomething(int a, int b) {
//   //   if (!freeze) {
//   //     setState(() {
//   //       freeze = true;
//   //       if (step == 0) {
//   //         pressed = [a, b];
//   //         freeze = false;
//   //       } else {
//   //         Future.delayed(Duration(seconds: 1), () {
//   //           if (matrix[a][b] == matrix[pressed[0]][pressed[1]]) {
//   //             // Update logic to "remove" or mark as found
//   //             found += 2;
//   //           }
//   //           // Reset or update UI based on game logic
//   //           setState(() {
//   //             freeze = false;
//   //           });

//   //           if (found == horCards * vertCards) {
//   //             Duration finalTime = DateTime.now().difference(startTime);
//   //             print("Final time: ${finalTime.inSeconds} seconds");
//   //           }
//   //         });
//   //       }
//   //       step = 1 - step;
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Memory Game'),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: vertCards,
//         ),
//         itemCount: horCards * vertCards,
//         itemBuilder: (context, index) {
//           int x = index ~/ vertCards;
//           int y = index % vertCards;
//           return GestureDetector(
//             onTap: () => doSomething(x, y),
//             child: Card(
//               child: Center(child: Text(freeze ? matrix[x][y].toString() : '')),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // class _MemoryGamePageState extends State<MemoryGamePage> {
// //   // Game state variables and logic will be here

// //   @override
// //   Widget build(BuildContext context) {
// //     // Build your game's UI here
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Memory Game'),
// //       ),
// //       body: GridView.builder(
// //         itemCount: 30, // Number of cards
// //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 5, // Number of cards in a row
// //         ), 
// //         itemBuilder: (context, index) {
// //           // Build your card widgets here
// //         },  
// //         // Build your grid of cards here
// //       ),
// //     );
// //   }
// // }

// // class CardModel {
// //   String imageUrl;
// //   bool isFlipped = false;
// //   bool isMatched = false;

// //   CardModel(this.imageUrl);
// // }

// // GridView buildGrid() {
// //   // You'll need to initialize a list of cards and implement game logic
// //   return GridView.builder(
// //     itemCount: 30, // Number of cards
// //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //       crossAxisCount: 5, // Number of cards in a row
// //     ),
// //     itemBuilder: (context, index) {
// //       // Build your card widgets here
// //     },
// //   );
// // }
