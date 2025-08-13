import 'package:chess_game/models/piece.dart';
import 'package:flutter/material.dart';
import 'package:chess_game/constants/colors.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;
  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.isValidMove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    // if sellected, square is  green
    if (isSelected) {
      squareColor = MyColor.green;
    } else if (isValidMove) {
      squareColor = MyColor.lightGreen;
    }
    //otherwise, the color is lightGrey and darkGrey
    else {
      squareColor = isWhite ? MyColor.lightGrey : MyColor.darkGrey;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(isValidMove ? 4 : 0),
        color: squareColor,
        child: piece != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  piece!.imgPath,
                  color: piece!.isWhite ? MyColor.white : MyColor.black,
                ),
              )
            : null,
      ),
    );
  }
}
