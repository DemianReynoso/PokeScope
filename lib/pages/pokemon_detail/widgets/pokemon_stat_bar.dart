import 'package:flutter/material.dart';

class PokemonStatBar extends StatelessWidget {
  final String name;
  final int value;
  final Color barColor;
  final Color backgroundColor;
  final Color textColor;

  const PokemonStatBar({
    super.key,
    required this.name,
    required this.value,
    required this.barColor,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              name.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value.toString().padLeft(3),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 255,
                backgroundColor: backgroundColor,
                color: barColor,
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}