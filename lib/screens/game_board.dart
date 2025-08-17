import 'package:chess_game/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:chess_game/widgets/widgets.dart';
import 'package:chess_game/models/piece.dart';
import 'package:chess_game/helper/helper_methods.dart';
import 'package:chess_game/constants/colors.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //2-d list represent chessboard
  late List<List<ChessPiece?>> board;

  //The currently selected piece
  //If no pieces seleceted this will be
  ChessPiece? selectedPiece;

  // the row index of selected square
  // -1 is default value means nothing has been selected
  int selectedRow = -1;

  // the coloumn index of selected square
  // -1 is default value means nothing has been selected
  int selectedColoumn = -1;

  // A list of valid  moves of selected piece
  // each move is represented as a list with two element : row and column
  List<List<int>> validMoves = [];

  // A list of white piece that have been taken by the black player
  List<ChessPiece> whitePieceTaken = [];

  // A list of black piece that have been taken by the black player
  List<ChessPiece> blackPieceTaken = [];

  // A boo to indicate whose turn it is
  bool iswhiteTurn = true;

  @override
  void initState() {
    super.initState();
    _initializedBoad();
  }

  // initialize board
  void _initializedBoad() {
    //initialize  the board with null, meaning no pieces in those positions
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (index) => List.generate(8, (index) => null),
    );

    //place king
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imgPath: 'assets/chess_pieces/king.png',
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imgPath: 'assets/chess_pieces/king.png',
    );

    //place queen
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imgPath: 'assets/chess_pieces/queen.png',
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imgPath: 'assets/chess_pieces/queen.png',
    );

    //place rook
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imgPath: 'assets/chess_pieces/rook.png',
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imgPath: 'assets/chess_pieces/rook.png',
    );
    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imgPath: 'assets/chess_pieces/rook.png',
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imgPath: 'assets/chess_pieces/rook.png',
    );

    //place knight
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imgPath: 'assets/chess_pieces/knight.png',
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imgPath: 'assets/chess_pieces/knight.png',
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imgPath: 'assets/chess_pieces/knight.png',
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imgPath: 'assets/chess_pieces/knight.png',
    );

    //place bishop
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imgPath: 'assets/chess_pieces/bishop.png',
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imgPath: 'assets/chess_pieces/bishop.png',
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imgPath: 'assets/chess_pieces/bishop.png',
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imgPath: 'assets/chess_pieces/bishop.png',
    );
    //place pawn
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imgPath: 'assets/chess_pieces/pawn.png');
      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: true,
          imgPath: 'assets/chess_pieces/pawn.png');
    }
    board = newBoard;
  }

  // user selected piece
  void pieceSelected(int row, int column) {
    setState(() {
      // NO piece has been selected yet, this is the first selection
      if (selectedPiece == null && board[row][column] != null) {
        if (board[row][column]!.isWhite == iswhiteTurn) {
          selectedPiece = board[row][column];
          selectedRow = row;
          selectedColoumn = column;
        }
      }
      // There is a piece already selected and the user taps on a square that is a valid move
      else if (board[row][column] != null &&
          board[row][column]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][column];
        selectedRow = row;
        selectedColoumn = column;
      }

      // if there is a piece selected & user taps on a square that is a valid move
      else if (selectedPiece != null &&
          validMoves
              .any((element) => element[0] == row && element[1] == column)) {
        movePiece(row, column);
      }

      // If piece is selected , calculate its valid moves
      validMoves =
          calcuateRawValidMoves(selectedRow, selectedColoumn, selectedPiece);
    });
  }

  //Calculate raw valid moves
  List<List<int>> calcuateRawValidMoves(
    int row,
    int column,
    ChessPiece? piece,
  ) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    // Different direction based on their color
    int direction = piece.isWhite ? -1 : 1;
    switch (piece.type) {
      case ChessPieceType.pawn:
        // pawns can move 2 square forward if they are in intialized position
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, column) &&
              board[row + 2 * direction][column] == null &&
              board[row + direction][column] == null) {
            candidateMoves.add([row + 2 * direction, column]);
          }
        }
        // pawns can move forward, if the square is not occupied
        if (isInBoard(row + direction, column) &&
            board[row + direction][column] == null) {
          candidateMoves.add([row + direction, column]);
        }

        // pawns can  kill diagonally
        if (isInBoard(row + direction, column - 1) &&
            board[row + direction][column - 1] != null &&
            board[row + direction][column - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, column - 1]);
        }
        if (isInBoard(row + direction, column + 1) &&
            board[row + direction][column + 1] != null &&
            board[row + direction][column + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, column + 1]);
        }
        break;

      case ChessPieceType.rook:
        // horizontal and vertical direction
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null) {
              if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newColumn]);
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-2, 1], // up 2 right 1
          [-1, -2], // up 1 left 2
          [-1, 2], // up 1 right 2
          [1, -2], // down 1 left 2
          [1, 2], // down 1 right 2
          [2, -1], // down 2 left 1
          [2, 1], // down 2 right 1
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newColumn = column + move[1];
          if (!isInBoard(newRow, newColumn)) {
            continue;
          }
          if (board[newRow][newColumn] != null) {
            if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newColumn]); //capture
            }
            continue; // Blocked
          }
          candidateMoves.add([newRow, newColumn]);
        }
        break;

      case ChessPieceType.bishop:
        var directions = [
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null) {
              if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newColumn]); //capture
              }
              break;
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        // king can move in all 8 direction up down left right and diagonals
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //doen right
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newColumn = column + direction[1];
          if (!isInBoard(newRow, newColumn)) {
            continue;
          }
          if (board[newRow][newColumn] != null) {
            if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newColumn]);
            }
            continue; //
          }
          candidateMoves.add([newRow, newColumn]);
        }
        break;
      case ChessPieceType.queen:
        // queen can move in all 8 direction up down left right and diagonals
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //doen right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null) {
              if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newColumn]);
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      default:
    }
    return candidateMoves;
  }

  // Move piece
  void movePiece(int newRow, int newCol) {
    // if the new sport have enemy piece
    if (board[newRow][newCol] != null) {
      // add the captured piece to the appropriate list
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePieceTaken.add(capturedPiece);
      } else {
        blackPieceTaken.add(capturedPiece);
      }
    }

    //move the piece and clear the old sport
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedColoumn] = null;

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedColoumn = -1;
      validMoves = [];
    });

    // Change turn
    iswhiteTurn = !iswhiteTurn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.lightBlue100,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // opens the drawer using the Scaffold context
              },
            );
          },
        ),
        title: const Text('Chess Game'),
        backgroundColor: MyColor.blue,
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          //WHite piece taken
          Expanded(
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: whitePieceTaken.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) => DeadPiece(
                  imgPath: whitePieceTaken[index].imgPath,
                  isWhite: true,
                ),
              ),
            ),
          ),

          // Chess boards
          Expanded(
            flex: 3,
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 8 * 8,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  //get row column position of the square
                  int row = index ~/ 8;
                  int column = index % 8;

                  // check if the square is selected
                  bool isSelected =
                      selectedRow == row && selectedColoumn == column;

                  //check if the square is valid move
                  bool isValidMove = false;
                  for (var position in validMoves) {
                    //compare row and column
                    if (position[0] == row && position[1] == column) {
                      isValidMove = true;
                    }
                  }
                  return Square(
                    isSelected: isSelected,
                    isWhite: isWhite(index),
                    piece: board[row][column],
                    isValidMove: isValidMove,
                    onTap: () => pieceSelected(row, column),
                  );
                },
              ),
            ),
          ),

          //Black piece taken
          Expanded(
            child: Center(
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: blackPieceTaken.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) => DeadPiece(
                        imgPath: blackPieceTaken[index].imgPath,
                        isWhite: false,
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
