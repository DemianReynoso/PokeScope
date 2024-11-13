import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../constants/pokemon_constants.dart';
import '../../queries/pokemon_queries.dart';
import '../../utils/string_utils.dart';
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

  void _handlePokemonTap(BuildContext context, int pokemonId) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.pokemonDetail,
      arguments: {'id': pokemonId},
    );
  }

  Widget _buildSprite(String spriteUrl) {
    return Image.network(
      spriteUrl,
      height: 200,
      width: 200,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox(
          height: 200,
          width: 200,
          child: Center(child: Icon(Icons.error)),
        );
      },
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

  Widget _buildDescription(String description, int height, int weight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            description.replaceAll('\n', ' '),
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PokemonMetric(
              label: PokemonConstants.heightLabel,
              value: StringUtils.formatHeight(height),
            ),
            PokemonMetric(
              label: PokemonConstants.weightLabel,
              value: StringUtils.formatWeight(weight),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAbilities(List<dynamic> abilities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PokemonConstants.abilitiesTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...abilities.map(
              (ability) => PokemonAbilityCard(
            name: ability['pokemon_v2_ability']['name'],
            description: ability['pokemon_v2_ability']
            ['pokemon_v2_abilityflavortexts'][0]['flavor_text'],
            isHidden: ability['is_hidden'],
          ),
        ),
      ],
    );
  }

  Widget _buildStats(List<dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PokemonConstants.baseStatsTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...stats.map(
              (stat) => PokemonStatBar(
            name: stat['pokemon_v2_stat']['name'],
            value: stat['base_stat'],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Query(
        options: QueryOptions(
          document: gql(PokemonQueries.fetchPokemonDetails),
          variables: {'pokemonId': pokemonId},
        ),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          final pokemon = result.data?['pokemon_v2_pokemon_by_pk'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  PokemonHeader(
                    name: pokemon['name'],
                    id: pokemon['id'],
                  ),
                  const SizedBox(height: 24),
                  _buildSprite(pokemon['pokemon_v2_pokemonsprites'][0]['sprites']),
                  const SizedBox(height: 16),
                  _buildTypes(pokemon['pokemon_v2_pokemontypes']),
                  const SizedBox(height: 24),
                  _buildDescription(
                    pokemon['pokemon_v2_pokemonspecy']
                    ['pokemon_v2_pokemonspeciesflavortexts'][0]['flavor_text'],
                    pokemon['height'],
                    pokemon['weight'],
                  ),
                  const SizedBox(height: 24),
                  _buildAbilities(pokemon['pokemon_v2_pokemonabilities']),
                  const SizedBox(height: 24),
                  _buildStats(pokemon['pokemon_v2_pokemonstats']),
                  const SizedBox(height: 24),
                  PokemonEvolutionChain(
                    evolutionChainData: result.data?['pokemon_v2_evolutionchain'][0],
                    onPokemonTap: (pokemonId) => _handlePokemonTap(context, pokemonId),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}