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

  List<Map<String, dynamic>> _organizeEvolutionChain(List<dynamic> species) {
    final List<Map<String, dynamic>> evolutionStages = [];
    final baseForm = species.firstWhere(
          (s) => s['evolves_from_species_id'] == null,
    );
    evolutionStages.add(baseForm);

    while (true) {
      final currentStage = evolutionStages.last;
      final nextEvolution = species.firstWhere(
            (s) => s['evolves_from_species_id'] == currentStage['id'],
        orElse: () => null,
      );

      if (nextEvolution == null) break;
      evolutionStages.add(nextEvolution);
    }

    return evolutionStages;
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
    final evolutionStages = _organizeEvolutionChain(species);

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < evolutionStages.length; i++) ...[
                  EvolutionPokemonCard(
                    pokemonData: evolutionStages[i]['pokemon_v2_pokemons'][0],
                    speciesData: evolutionStages[i],
                    onTap: () => onPokemonTap(evolutionStages[i]['id']),
                    textColor: textColor,
                  ),
                  if (i < evolutionStages.length - 1) ...[
                    EvolutionArrow(
                      triggerText: _getEvolutionTrigger(evolutionStages[i + 1]),
                      textColor: textColor,
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}