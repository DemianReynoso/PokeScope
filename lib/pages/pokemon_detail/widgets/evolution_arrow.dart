import 'package:flutter/material.dart';

class EvolutionArrow extends StatelessWidget {
  final String triggerText;
  final Color textColor;

  const EvolutionArrow({
    super.key,
    required this.triggerText,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_forward, color: textColor),
          if (triggerText.isNotEmpty)
            Text(
              triggerText,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            ),
        ],
      ),
    );
  }
}
