import 'package:chess_game/constants/colors.dart';
import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final String imgPath;
  final bool isWhite;
  const DeadPiece({super.key, required this.imgPath, required this.isWhite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        imgPath,
        color: isWhite ? MyColor.deadWhite : MyColor.deadBlack,
      ),
    );
  }
}
