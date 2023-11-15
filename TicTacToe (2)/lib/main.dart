import 'package:flutter/material.dart';

/// Main entry point of the application.
void main() {
  runApp(TicTacToeApp());
}

/// The main application widget.
class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToeGame(),
    );
  }
}

/// The stateful widget representing the Tic Tac Toe game.
class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

/// The state for the Tic Tac Toe game.
class _TicTacToeGameState extends State<TicTacToeGame> {
  // Functional Requirement 1: Keep track of cells
  List<String> cells = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameActive = true;
  int scoreX = 0;
  int scoreO = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe Game'),
      ),
      body: _buildGameBody(),
    );
  }

  /// Builds the main body of the game.
  Widget _buildGameBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildScoreDisplay(), // Functional Requirement 2: Display scores
        SizedBox(height: 20),
        Expanded(
            child:
                _buildGameGrid()), // Functional Requirement 3: Display game grid
        SizedBox(height: 10),
        Text(
          'Current Player: $currentPlayer',
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
        SizedBox(height: 10),
        Text(
          gameActive ? '' : getGameResultMessage(),
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: resetGame,
          child: Text('Reset Game'),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
        ),
      ],
    );
  }

  /// Builds the display for player scores.
  Widget _buildScoreDisplay() {
    return Text(
      'Player X: $scoreX | Player O: $scoreO',
      style: TextStyle(fontSize: 18, color: Colors.green),
    );
  }

  /// Builds the game grid.
  Widget _buildGameGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: cells.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => handleCellClick(index),
          child: _buildGridCell(index),
        );
      },
    );
  }

  /// Builds an individual cell within the game grid.
  Widget _buildGridCell(int index) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: cells[index].isEmpty
            ? Colors.white
            : cells[index] == 'Winner'
                ? Colors.yellow
                : Colors.grey[200],
      ),
      child: Text(
        cells[index],
        style: TextStyle(
          fontSize: 32,
          color: cells[index] == 'X' ? Colors.blue : Colors.green,
        ),
      ),
    );
  }

  /// Handles the click on a cell.
  void handleCellClick(int index) {
    if (gameActive && cells[index].isEmpty) {
      setState(() {
        cells[index] = currentPlayer;
        if (checkWinner()) {
          showMessage('$currentPlayer wins!');
          updateScore(currentPlayer);
          gameActive = false;
        } else if (checkTie()) {
          showMessage('It\'s a tie!');
          gameActive = false;
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          showMessage('Current Player: $currentPlayer');
        }
      });
    }
  }

  /// Checks if there is a winner.
  bool checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (List<int> combination in winningCombinations) {
      int a = combination[0];
      int b = combination[1];
      int c = combination[2];

      if (cells[a].isNotEmpty && cells[a] == cells[b] && cells[a] == cells[c]) {
        highlightWinnerCells(combination);
        return true;
      }
    }

    return false;
  }

  /// Highlights the cells that form the winning combination.
  void highlightWinnerCells(List<int> combination) {
    setState(() {
      for (int index in combination) {
        // Change cell decoration to indicate the winning combination
        cells[index] = 'Winner';
      }
    });
  }

  /// Checks if the game is a tie.
  bool checkTie() {
    return !cells.any((cell) => cell.isEmpty);
  }

  /// Returns a message indicating the result of the game.
  String getGameResultMessage() {
    if (checkWinner()) {
      return '$currentPlayer wins!';
    } else if (checkTie()) {
      return 'It\'s a tie!';
    } else {
      return '';
    }
  }

  /// Displays a message to the user.
  void showMessage(String message) {
    // Implement a method to update the UI to display the message
    // You may use a SnackBar or another appropriate method
    // Example: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Updates the score for the winning player.
  void updateScore(String player) {
    setState(() {
      if (player == 'X') {
        scoreX++;
      } else {
        scoreO++;
      }
    });
  }

  /// Resets the game to its initial state.
  void resetGame() {
    setState(() {
      cells = List.filled(9, '');
      currentPlayer = 'X';
      gameActive = true;
      showMessage('Game has been reset.');
    });
  }
}

/// README:
/// Tic Tac Toe Game
///
/// This is a simple Flutter application that allows two players to play
/// Tic Tac Toe and keeps track of their scores. The game board is displayed
/// using a 3x3 grid, and players take turns clicking on cells to make their moves.
///
/// Features:
/// - Score tracking for Player X and Player O.
/// - Visual indicators for winning combinations.
/// - Reset button to start a new game.
///
/// Usage:
/// - Tap on an empty cell to make a move.
/// - The game will display the current player's turn and indicate the winner or a tie.
/// - Press the "Reset Game" button to start a new game.
