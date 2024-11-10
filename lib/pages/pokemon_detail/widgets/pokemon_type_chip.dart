import 'package:flutter/material.dart';

class PokemonTypeChip extends StatelessWidget {
  final String type;

  static const Map<String, Color> pokemonTypeColors = {
    'normal': Colors.grey,
    'fire': Colors.red,
    'water': Colors.blue,
    // ... resto de los colores
  };

  const PokemonTypeChip({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = pokemonTypeColors[type] ?? Colors.grey;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: typeColor),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: typeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
