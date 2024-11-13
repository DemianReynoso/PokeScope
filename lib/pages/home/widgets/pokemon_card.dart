import 'package:flutter/material.dart';
import 'pokemon_type_chip.dart';

class PokemonCard extends StatelessWidget {
  final Map<String, dynamic> pokemon;
  final Map<String, Color> typeColors;
  final String Function(String) capitalize;
  final Function(BuildContext, int) onTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.typeColors,
    required this.capitalize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = capitalize(pokemon['name']);
    final types = pokemon['pokemon_v2_pokemontypes'];
    final primaryType = types[0]['pokemon_v2_type']['name'];
    final secondaryType = types.length > 1 ? types[1]['pokemon_v2_type']['name'] : null;
    final spriteUrl = pokemon['pokemon_v2_pokemonsprites'][0]['sprites'];

    return InkWell(
      onTap: () => onTap(context, pokemon['id']),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: typeColors[primaryType]?.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: typeColors[primaryType] ?? Colors.grey),
        ),
        child: Row(
          children: [
            Image.network(
              spriteUrl ?? '',
              height: 80,
              width: 80,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 80,
                  width: 80,
                  child: Center(child: Icon(Icons.error)),
                );
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      PokemonTypeChip(
                        type: primaryType,
                        typeColor: typeColors[primaryType] ?? Colors.grey,
                        capitalize: capitalize,
                      ),
                      if (secondaryType != null) ...[
                        const SizedBox(width: 8),
                        PokemonTypeChip(
                          type: secondaryType,
                          typeColor: typeColors[secondaryType] ?? Colors.grey,
                          capitalize: capitalize,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}