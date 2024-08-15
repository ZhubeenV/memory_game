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

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  int horCards = 4; // Number of cards horizontally
  int vertCards = 4; // Number of cards vertically
  late List<List<int>> matrix;
  bool freeze = false;
  List<int>? firstCard; // Store the position of the first card clicked
  late List<List<bool>> flippedCards; // Track which cards are flipped
  late List<List<bool>> matchedCards; // Track which cards have been matched
  late List<List<AnimationController>> _controllers;
  late List<List<Animation<double>>> _animations;
  late List<List<AnimationController>> _popFadeControllers;
  late List<List<Animation<double>>> _popAnimations;
  late List<List<Animation<double>>> _fadeAnimations;
  int found = 0;
  late DateTime startTime;

  // Duration settings
  Duration flipDuration = Duration(milliseconds: 300); // Time to flip a single card
  Duration checkDuration = Duration(milliseconds: 500); // Time cards stay flipped before checking
  Duration popFadeDuration = Duration(milliseconds: 400); // Duration for pop and fade animations

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  @override
  void dispose() {
    for (var controllerList in _controllers) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    for (var popFadeControllerList in _popFadeControllers) {
      for (var popFadeController in popFadeControllerList) {
        popFadeController.dispose();
      }
    }
    super.dispose();
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

    // Initialize controllers and animations
    _controllers = List.generate(horCards, (_) => List.generate(vertCards, (_) => AnimationController(vsync: this, duration: flipDuration)));
    _animations = List.generate(horCards, (i) => List.generate(vertCards, (j) {
      return Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controllers[i][j],
        curve: Curves.easeInOut,
      ));
    }));

    // Initialize pop and fade controllers and animations
    _popFadeControllers = List.generate(horCards, (_) => List.generate(vertCards, (_) => AnimationController(vsync: this, duration: popFadeDuration)));
    _popAnimations = List.generate(horCards, (i) => List.generate(vertCards, (j) {
      return Tween<double>(begin: 1, end: 1.5).animate(CurvedAnimation(
        parent: _popFadeControllers[i][j],
        curve: Curves.easeOut,
      ));
    }));
    _fadeAnimations = List.generate(horCards, (i) => List.generate(vertCards, (j) {
      return Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: _popFadeControllers[i][j],
        curve: Curves.easeOut,
      ));
    }));

    startTime = DateTime.now();
  }

  void flipCard(int x, int y) {
    if (!freeze && !flippedCards[x][y] && !matchedCards[x][y]) {
      setState(() {
        flippedCards[x][y] = true;
      });

      _controllers[x][y].forward(); // Start the flip animation

      if (firstCard == null) {
        // First card flipped
        firstCard = [x, y];
      } else {
        // Second card flipped, check for match
        freeze = true;
        Future.delayed(checkDuration, () {
          if (matrix[x][y] == matrix[firstCard![0]][firstCard![1]]) {
            // Cards match, play the pop and fade animations simultaneously
            _popFadeControllers[x][y].forward();
            _popFadeControllers[firstCard![0]][firstCard![1]].forward();
            setState(() {
              matchedCards[x][y] = true;
              matchedCards[firstCard![0]][firstCard![1]] = true;
            });
            found += 2;
          } else {
            // Cards don't match, flip them back over
            _controllers[x][y].reverse(); // Reverse the flip animation
            _controllers[firstCard![0]][firstCard![1]].reverse();
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

  Widget buildCard(int x, int y) {
    return AnimatedBuilder(
      animation: _animations[x][y],
      builder: (context, child) {
        final isFlipped = _animations[x][y].value >= 0.5;
        return GestureDetector(
          onTap: () {
            if (!isFlipped) {
              flipCard(x, y);
            }
          },
          child: Transform(
            transform: Matrix4.rotationY(_animations[x][y].value * 3.1416),
            alignment: Alignment.center,
            child: isFlipped
                ? matchedCards[x][y]
                    ? ScaleTransition(
                        scale: _popAnimations[x][y],
                        child: FadeTransition(
                          opacity: _fadeAnimations[x][y],
                          child: Card(
                            key: ValueKey<int>(matrix[x][y]),
                            child: Center(
                              child: Text(matrix[x][y].toString()),
                            ),
                          ),
                        ),
                      )
                    : Card(
                        key: ValueKey<int>(matrix[x][y]),
                        child: Center(
                          child: Text(matrix[x][y].toString()),
                        ),
                      )
                : Card(
                    key: ValueKey<int>(matrix[x][y]),
                    child: Center(
                      child: Text(''), // Empty text when the card is unflipped
                    ),
                  ),
          ),
        );
      },
    );
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
          return buildCard(x, y);
        },
      ),
    );
  }
}
