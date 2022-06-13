
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../blocs/puzzle/puzzle_bloc.dart';
import '../models/tile.dart';

abstract class PuzzleLayoutDelegate extends Equatable{
  const PuzzleLayoutDelegate();

  Widget startSectionBuilder(PuzzleState state);

  Widget endSectionBuilder(PuzzleState state);

  Widget backgroundBuilder(PuzzleState state);

  Widget boardBuilder(int size, List<Widget> tiles);

  Widget tileBuilder(Tile tile, PuzzleState state);

  Widget whitespaceTileBuilder();
}