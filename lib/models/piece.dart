enum ChessPieceType { bishop, king, queen, knight, rook, pawn }

class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  final String imgPath;

  ChessPiece(
      {required this.type, required this.isWhite, required this.imgPath});
}
