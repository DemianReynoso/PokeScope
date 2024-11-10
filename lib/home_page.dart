import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatelessWidget {
  // Actualizamos la consulta para usar los sprites oficiales
  final String fetchPokemonQuery = """
  query getPokemonForHomepage(\$limit: Int, \$offset: Int) {
    pokemon_v2_pokemon(limit: \$limit, offset: \$offset) {
      id
      name
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
""";

  static const Map<String, Color> pokemonTypeColors = {
    'normal': Colors.grey,
    'fire': Colors.red,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.yellow,
    'ice': Colors.lightBlueAccent,
    'fighting': Colors.brown,
    'poison': Colors.purple,
    'ground': Colors.brown,
    'flying': Colors.lightBlue,
    'psychic': Colors.pink,
    'bug': Colors.lightGreen,
    'rock': Colors.brown,
    'ghost': Colors.deepPurple,
    'dragon': Colors.indigo,
    'dark': Colors.black,
    'steel': Colors.blueGrey,
    'fairy': Colors.pinkAccent,
  };

  const HomePage({super.key});

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildTypeChip(String type, Color typeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: typeColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        capitalize(type),
        style: TextStyle(
          fontSize: 14,
          color: typeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(fetchPokemonQuery),
          // variables: const {
          //   'limit': 20,  // Puedes ajustar este número según necesites
          //   'offset': 0
          // },
        ),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          final pokemons = result.data?['pokemon_v2_pokemon'] ?? [];
          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];
              final name = capitalize(pokemon['name']);
              final types = pokemon['pokemon_v2_pokemontypes'];
              final primaryType = types[0]['pokemon_v2_type']['name'];
              final secondaryType = types.length > 1 ? types[1]['pokemon_v2_type']['name'] : null;
              final spriteUrl = pokemon['pokemon_v2_pokemonsprites'][0]['sprites'];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: pokemonTypeColors[primaryType]?.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: pokemonTypeColors[primaryType] ?? Colors.grey),
                ),
                child: Row(
                  children: [
                    // Ajustamos el tamaño de la imagen ya que los sprites oficiales son más grandes
                    Image.network(
                      spriteUrl ?? '',
                      height: 80,  // Aumentamos el tamaño
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
                              _buildTypeChip(
                                primaryType,
                                pokemonTypeColors[primaryType] ?? Colors.grey,
                              ),
                              if (secondaryType != null) ...[
                                const SizedBox(width: 8),
                                _buildTypeChip(
                                  secondaryType,
                                  pokemonTypeColors[secondaryType] ?? Colors.grey,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}