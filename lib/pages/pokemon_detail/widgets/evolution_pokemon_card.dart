import 'package:flutter/material.dart';

class EvolutionPokemonCard extends StatelessWidget {
  final Map<String, dynamic> pokemonData;
  final Map<String, dynamic> speciesData;
  final VoidCallback onTap;
  final Color textColor;

  const EvolutionPokemonCard({
    super.key,
    required this.pokemonData,
    required this.speciesData,
    required this.onTap,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.network(
            pokemonData['pokemon_v2_pokemonsprites'][0]['sprites'],
            height: 80,
            width: 80,
          ),
          Text(
            speciesData['name'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}