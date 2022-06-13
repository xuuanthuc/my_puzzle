import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/theme/theme_bloc.dart';
import '../../../components/app_logo.dart';

final puzzleLogoKey = GlobalKey(debugLabel: "puzzle_logo");

class PuzzleLogo extends StatelessWidget {
  const PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return AppLogo(
      key: puzzleLogoKey,
      isColored: theme.isLogoColored,
    );
  }
}

