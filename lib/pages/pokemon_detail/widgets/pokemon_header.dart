import 'package:flutter/material.dart';

import '../../../utils/string_utils.dart';

class PokemonHeader extends StatelessWidget {
  final String name;
  final int id;
  final Color textColor; // Nuevo parámetro

  const PokemonHeader({
    super.key,
    required this.name,
    required this.id,
    required this.textColor, // Nuevo requerido
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          StringUtils.capitalize(name),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          '#${id.toString().padLeft(3, '0')}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}