import 'package:flutter/material.dart';

class PokemonTypeChip extends StatelessWidget {
  final String type;
  final Color typeColor;
  final String Function(String) capitalize;

  const PokemonTypeChip({
    super.key,
    required this.type,
    required this.typeColor,
    required this.capitalize,
  });

  @override
  Widget build(BuildContext context) {
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
        capitalize(type),
        style: TextStyle(
          fontSize: 14,
          color: typeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}