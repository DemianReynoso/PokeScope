import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../routes/app_routes.dart';
import 'widgets/pokemon_search_bar.dart';
import 'widgets/filter_bar.dart';
import 'widgets/pokemon_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String selectedType = '';
  int selectedGeneration = 0;
  String sortBy = 'id';
  bool sortAscending = true;

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

  final String fetchPokemonQuery = """
    query getPokemonForHomepage(
      \$limit: Int, 
      \$offset: Int,
      \$where: pokemon_v2_pokemon_bool_exp,
      \$orderBy: [pokemon_v2_pokemon_order_by!]
    ) {
      pokemon_v2_pokemon(
        limit: \$limit, 
        offset: \$offset,
        where: \$where,
        order_by: \$orderBy
      ) {
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
        pokemon_v2_pokemonspecy {
          generation_id
        }
      }
    }
  """;

  List<String> get pokemonTypes => pokemonTypeColors.keys.toList();
  final List<int> generations = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  void _navigateToPokemonDetail(BuildContext context, int pokemonId) {
    Navigator.pushNamed(
      context,
      AppRoutes.pokemonDetail,
      arguments: {'id': pokemonId},
    );
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Map<String, dynamic> _buildWhereClause() {
    Map<String, dynamic> where = {};

    if (searchQuery.isNotEmpty) {
      where['name'] = {'_ilike': '%$searchQuery%'};
    }

    if (selectedType.isNotEmpty) {
      where['pokemon_v2_pokemontypes'] = {
        'pokemon_v2_type': {
          'name': {'_eq': selectedType}
        }
      };
    }

    if (selectedGeneration > 0) {
      where['pokemon_v2_pokemonspecy'] = {
        'generation_id': {'_eq': selectedGeneration}
      };
    }

    return where;
  }

  List<Map<String, dynamic>> _buildOrderBy() {
    String field = sortBy == 'name' ? 'name' : 'id';
    String direction = sortAscending ? 'asc' : 'desc';
    return [{field: direction}];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                PokemonSearchBar(
                  searchQuery: searchQuery,
                  onSearchChanged: (value) => setState(() => searchQuery = value),
                ),
                const SizedBox(height: 8),
                FilterBar(
                  selectedType: selectedType,
                  selectedGeneration: selectedGeneration,
                  sortBy: sortBy,
                  sortAscending: sortAscending,
                  pokemonTypes: pokemonTypes,
                  generations: generations,
                  onTypeChanged: (value) => setState(() => selectedType = value ?? ''),
                  onGenerationChanged: (value) => setState(() => selectedGeneration = value ?? 0),
                  onSortTypeChanged: (index) => setState(() => sortBy = index == 0 ? 'id' : 'name'),
                  onSortDirectionChanged: () => setState(() => sortAscending = !sortAscending),
                  capitalize: capitalize,
                ),
              ],
            ),
          ),
          Expanded(
            child: Query(
              options: QueryOptions(
                document: gql(fetchPokemonQuery),
                variables: {
                  'limit': 50,
                  'offset': 0,
                  'where': _buildWhereClause(),
                  'orderBy': _buildOrderBy(),
                },
              ),
              builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
                return PokemonList(
                  result: result,
                  typeColors: pokemonTypeColors,
                  capitalize: capitalize,
                  onPokemonTap: _navigateToPokemonDetail,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}