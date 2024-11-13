import 'package:flutter/material.dart';
import '../../../constants/pokemon_constants.dart';
import '../../../utils/string_utils.dart';
import 'pokemon_type_chip.dart';

class PokemonCard extends StatelessWidget {
  final Map<String, dynamic> pokemon;
  final Function(BuildContext, int) onTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = StringUtils.capitalize(pokemon['name']);
    final types = pokemon['pokemon_v2_pokemontypes'];
    final primaryType = types[0]['pokemon_v2_type']['name'];
    final secondaryType = types.length > 1 ? types[1]['pokemon_v2_type']['name'] : null;
    final spriteUrl = pokemon['pokemon_v2_pokemonsprites'][0]['sprites'];
    final primaryColor = PokemonConstants.typeColors[primaryType] ?? Colors.grey;

    return InkWell(
      onTap: () => onTap(context, pokemon['id']),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor),
        ),
        child: Row(
          children: [
            _buildPokemonImage(spriteUrl),
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
                      ),
                      if (secondaryType != null) ...[
                        const SizedBox(width: 8),
                        PokemonTypeChip(
                          type: secondaryType,
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

  Widget _buildPokemonImage(String? spriteUrl) {
    return Image.network(
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
    );
  }
}