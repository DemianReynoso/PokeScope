import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../constants/pokemon_constants.dart';
import '../../queries/pokemon_queries.dart';
import '../../routes/app_routes.dart';
import 'widgets/pokemon_header.dart';
import 'widgets/pokemon_type_chip.dart';
import 'widgets/pokemon_metric.dart';
import 'widgets/pokemon_ability_card.dart';
import 'widgets/pokemon_stat_bar.dart';
import 'widgets/pokemon_evolution_chain.dart';

class PokemonDetailPage extends StatelessWidget {
  final int pokemonId;

  const PokemonDetailPage({
    super.key,
    required this.pokemonId,
  });

  Color _getTextColor(Color baseColor, {bool isTitle = false}) {
    final greyAmount = isTitle ? 0.3 : 0.5;
    return Color.lerp(baseColor, Colors.grey[800]!, greyAmount)!;
  }

  void _handlePokemonTap(BuildContext context, int pokemonId) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.pokemonDetail,
      arguments: {'id': pokemonId},
    );
  }

  Widget _buildTypes(List<dynamic> types) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: types
          .map((type) => PokemonTypeChip(
        type: type['pokemon_v2_type']['name'],
      ))
          .toList(),
    );
  }

  Widget _buildDescription(String description, int height, int weight, Color backgroundColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            description.replaceAll('\n', ' '),
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PokemonMetric(
              label: PokemonConstants.heightLabel,
              value: '${height / 10} m',
              backgroundColor: backgroundColor,
              textColor: textColor,
              labelColor: textColor.withOpacity(0.8),
            ),
            PokemonMetric(
              label: PokemonConstants.weightLabel,
              value: '${weight / 10} kg',
              backgroundColor: backgroundColor,
              textColor: textColor,
              labelColor: textColor.withOpacity(0.8),
            ),
          ],
        ),
      ],
    );
  }

  _buildAbilities(List<dynamic> abilities, Color backgroundColor, Color accentColor, Color textColor, Color titleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PokemonConstants.abilitiesTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        ...abilities.map(
              (ability) {
            final description = ability['pokemon_v2_ability']
            ['pokemon_v2_abilityflavortexts'][0]['flavor_text'];

            return PokemonAbilityCard(
              name: ability['pokemon_v2_ability']['name'],
              description: description,
              isHidden: ability['is_hidden'],
              backgroundColor: backgroundColor,
              accentColor: accentColor,
              textColor: textColor,
              titleColor: titleColor,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStats(List<dynamic> stats, Color barColor, Color backgroundColor, Color textColor, Color titleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PokemonConstants.baseStatsTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        ...stats.map(
              (stat) => PokemonStatBar(
            name: stat['pokemon_v2_stat']['name'],
            value: stat['base_stat'],
            barColor: barColor,
            backgroundColor: backgroundColor,
            textColor: textColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(PokemonQueries.fetchPokemonDetails),
        variables: {'pokemonId': pokemonId},
      ),
      builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (result.hasException) {
          return Scaffold(
            body: Center(child: Text(result.exception.toString())),
          );
        }

        final pokemon = result.data?['pokemon_v2_pokemon_by_pk'];
        final primaryType = pokemon['pokemon_v2_pokemontypes'][0]['pokemon_v2_type']['name'];
        final primaryColor = PokemonConstants.typeColors[primaryType]!;

        final backgroundColor = Color.lerp(primaryColor, Colors.white, 0.60);
        final containerColor = Color.lerp(backgroundColor!, Colors.white, 0.60);
        final textColor = _getTextColor(primaryColor);
        final titleColor = _getTextColor(primaryColor, isTitle: true);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: PokemonHeader(
                          name: pokemon['name'],
                          id: pokemon['id'],
                          textColor: titleColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: containerColor,
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          pokemon['pokemon_v2_pokemonsprites'][0]['sprites'],
                          height: 200,
                          width: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 200,
                              width: 200,
                              child: Center(child: Icon(Icons.error)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTypes(pokemon['pokemon_v2_pokemontypes']),
                      const SizedBox(height: 24),
                      _buildDescription(
                        pokemon['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesflavortexts'][0]['flavor_text'],
                        pokemon['height'],
                        pokemon['weight'],
                        containerColor!,
                        textColor,
                      ),
                      const SizedBox(height: 24),
                      _buildAbilities(
                        pokemon['pokemon_v2_pokemonabilities'],
                        containerColor,
                        primaryColor,
                        textColor,
                        titleColor,
                      ),
                      const SizedBox(height: 24),
                      _buildStats(
                        pokemon['pokemon_v2_pokemonstats'],
                        primaryColor,
                        containerColor,
                        textColor,
                        titleColor,
                      ),
                      const SizedBox(height: 24),
                      PokemonEvolutionChain(
                        evolutionChainData: result.data?['pokemon_v2_evolutionchain'][0],
                        onPokemonTap: (id) => _handlePokemonTap(context, id),
                        backgroundColor: containerColor,
                        textColor: textColor,
                        titleColor: titleColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}