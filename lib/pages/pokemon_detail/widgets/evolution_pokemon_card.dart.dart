import 'package:flutter/material.dart';
import 'pokemon_type_chip.dart';

class EvolutionPokemonCard extends StatelessWidget {
  final Map<String, dynamic> pokemonData;
  final Map<String, dynamic> speciesData;
  final VoidCallback onTap;

  const EvolutionPokemonCard({
    super.key,
    required this.pokemonData,
    required this.speciesData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final types = pokemonData['pokemon_v2_pokemontypes'];
    final sprite = pokemonData['pokemon_v2_pokemonsprites'][0]['sprites'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.network(
              sprite,
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
            const SizedBox(height: 8),
            Text(
              speciesData['name'].toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: types
                  .map<Widget>((type) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: PokemonTypeChip(
                  type: type['pokemon_v2_type']['name'],
                ),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}