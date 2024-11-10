import 'package:flutter/material.dart';

class PokemonStatBar extends StatelessWidget {
  final String name;
  final int value;

  const PokemonStatBar({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final Color statColor = value < 50
        ? Colors.red
        : value < 90
        ? Colors.orange
        : Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                value.toString().padLeft(3),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: value / 255,
                    backgroundColor: statColor.withOpacity(0.1),
                    color: statColor,
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}