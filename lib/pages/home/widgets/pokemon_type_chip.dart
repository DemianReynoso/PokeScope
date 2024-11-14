import 'package:flutter/material.dart';
import '../../../constants/pokemon_constants.dart';
import '../../../utils/string_utils.dart';

class PokemonTypeChip extends StatelessWidget {
  final String type;

  const PokemonTypeChip({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = PokemonConstants.typeColors[type] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: typeColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        StringUtils.capitalize(type),
        style: TextStyle(
          fontSize: 14,
          color: typeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}