import 'package:flutter/material.dart';

class PokemonHeader extends StatelessWidget {
  final String name;
  final int id;

  const PokemonHeader({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name.toUpperCase(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '#${id.toString().padLeft(3, '0')}',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}