import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'widgets/pokemon_header.dart';
import 'widgets/pokemon_type_chip.dart';
import 'widgets/pokemon_metric.dart';
import 'widgets/pokemon_ability_card.dart';
import 'widgets/pokemon_stat_bar.dart';
import 'widgets/pokemon_evolution_chain.dart';

class PokemonDetailPage extends StatelessWidget {
  final int pokemonId;
  static const String fetchPokemonQuery = """
  query getPokemonDetails(\$pokemonId: Int!) {
  pokemon_v2_pokemon_by_pk(id: \$pokemonId) {
    id
    name
    height
    weight
    pokemon_v2_pokemonsprites {
      sprites(path: "other.official-artwork.front_default")
    }
    pokemon_v2_pokemontypes {
      pokemon_v2_type {
        name
      }
    }
    pokemon_v2_pokemonabilities {
      pokemon_v2_ability {
        name
        pokemon_v2_abilityflavortexts(where: {language_id: {_eq: 9}}, limit: 1) {
          flavor_text
        }
      }
      is_hidden
    }
    pokemon_v2_pokemonstats {
      base_stat
      pokemon_v2_stat {
        name
      }
    }
    pokemon_v2_pokemonspecy {
      pokemon_v2_pokemonspeciesflavortexts(where: {language_id: {_eq: 9}}, limit: 1) {
        flavor_text
      }
      evolution_chain_id
    }
  }
  # Consulta separada para la cadena evolutiva
  pokemon_v2_evolutionchain(where: {pokemon_v2_pokemonspecies: {pokemon_v2_pokemons: {id: {_eq: \$pokemonId}}}}) {
    pokemon_v2_pokemonspecies {
      name
      id
      evolves_from_species_id
      pokemon_v2_pokemonevolutions {
        min_level
        pokemon_v2_evolutiontrigger {
          name
        }
      }
      pokemon_v2_pokemons {
        pokemon_v2_pokemonsprites {
          sprites(path: "other.official-artwork.front_default")
        }
        pokemon_v2_pokemontypes {
          pokemon_v2_type {
            name
          }
        }
      }
    }
  }
}
"""; // Tu query actual

  const PokemonDetailPage({
    super.key,
    required this.pokemonId,
  });

  void _handlePokemonTap(BuildContext context, int pokemonId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PokemonDetailPage(pokemonId: pokemonId),
      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(description),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PokemonMetric(
              label: 'Height',
              value: '${height / 10} m',
            ),
            PokemonMetric(
              label: 'Weight',
              value: '${weight / 10} kg',
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
        const Text(
          'Abilities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        const Text(
          'Base Stats',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          document: gql(fetchPokemonQuery),
          variables: {'id': pokemonId},
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