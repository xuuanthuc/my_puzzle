import 'package:equatable/equatable.dart';
import 'package:puzzle_simple/models/position.dart';

class Tile extends Equatable {
  const Tile({
    required this.value,
    required this.correctPosition,
    required this.currentPosition,
    this.isWhiteSpace = false,
  });

  ///Giá trị đại diện cho vị trí chính xác của [Tile] trong list
  final int value;

  ///vi trí chính xác cho Puzzle đúng
  final Position correctPosition;

  final Position currentPosition;

  /// Cho biết [Tile] có phải là ô khoảng trắng hay không.
  final bool isWhiteSpace;

  Tile copyWith({required Position currentPosition}) {
    return Tile(
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      isWhiteSpace: isWhiteSpace,
    );
  }

  @override
  List<Object?> get props => [
        value,
        correctPosition,
        currentPosition,
        isWhiteSpace,
      ];
}
