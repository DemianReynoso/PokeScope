import 'package:flutter/material.dart';
import '../../../constants/pokemon_constants.dart';
import 'evolution_pokemon_card.dart';
import 'evolution_arrow.dart';

class PokemonEvolutionChain extends StatelessWidget {
  final Map<String, dynamic> evolutionChainData;
  final Function(int) onPokemonTap;
  final Color backgroundColor;
  final Color textColor;
  final Color titleColor;

  const PokemonEvolutionChain({
    super.key,
    required this.evolutionChainData,
    required this.onPokemonTap,
    required this.backgroundColor,
    required this.textColor,
    required this.titleColor,
  });

  List<List<Map<String, dynamic>>> _organizeEvolutionChain(List<dynamic> species) {
    final List<List<Map<String, dynamic>>> evolutionPaths = [];

    final baseForm = species.firstWhere(
          (s) => s['evolves_from_species_id'] == null,
    );

    final firstStageEvolutions = species.where(
            (s) => s['evolves_from_species_id'] == baseForm['id']
    ).toList();

    if (firstStageEvolutions.isEmpty) {
      evolutionPaths.add([baseForm]);
      return evolutionPaths;
    }

    for (final firstEvolution in firstStageEvolutions) {
      final secondStageEvolutions = species.where(
              (s) => s['evolves_from_species_id'] == firstEvolution['id']
      ).toList();

      if (secondStageEvolutions.isEmpty) {
        evolutionPaths.add([baseForm, firstEvolution]);
      } else {
        for (final secondEvolution in secondStageEvolutions) {
          evolutionPaths.add([baseForm, firstEvolution, secondEvolution]);
        }
      }
    }

    return evolutionPaths;
  }

  String _getEvolutionTrigger(Map<String, dynamic> species) {
    if (species['pokemon_v2_pokemonevolutions'].isEmpty) return '';

    final evolution = species['pokemon_v2_pokemonevolutions'][0];
    final triggerName = evolution['pokemon_v2_evolutiontrigger']['name'];
    final level = evolution['min_level'];

    if (triggerName == 'level-up' && level != null) {
      return 'Lvl $level';
    }

    return triggerName.replaceAll('-', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final species = evolutionChainData['pokemon_v2_pokemonspecies'];
    final evolutionPaths = _organizeEvolutionChain(species);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            PokemonConstants.evolutionChainTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 16),
          ...evolutionPaths.map((path) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < path.length; i++) ...[
                    EvolutionPokemonCard(
                      pokemonData: path[i]['pokemon_v2_pokemons'][0],
                      speciesData: path[i],
                      onTap: () => onPokemonTap(path[i]['id']),
                      textColor: textColor,
                    ),
                    if (i < path.length - 1) ...[
                      EvolutionArrow(
                        triggerText: _getEvolutionTrigger(path[i + 1]),
                        textColor: textColor,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}