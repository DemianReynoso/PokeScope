import 'package:flutter/material.dart';

class PokemonAbilityCard extends StatelessWidget {
  final String name;
  final String description;
  final bool isHidden;
  final Color backgroundColor;
  final Color accentColor;
  final Color textColor;
  final Color titleColor;

  const PokemonAbilityCard({
    super.key,
    required this.name,
    required this.description,
    required this.isHidden,
    required this.backgroundColor,
    required this.accentColor,
    required this.textColor,
    required this.titleColor,
  });

  String _cleanDescription(String text) {
    return text
        .replaceAll('\n', ' ')
        .replaceAll('\f', ' ')
        .replaceAll('\r', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final cleanDescription = _cleanDescription(description);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: titleColor,
                ),
              ),
              if (isHidden) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Hidden',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            cleanDescription,
            style: TextStyle(
              color: textColor,
              height: 1.5,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}