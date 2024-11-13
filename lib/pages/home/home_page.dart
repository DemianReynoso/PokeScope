import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../constants/pokemon_constants.dart';
import '../../queries/pokemon_queries.dart';
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
  String sortBy = HomeConstants.defaultSortField;
  bool sortAscending = true;

  void _navigateToPokemonDetail(BuildContext context, int pokemonId) {
    Navigator.pushNamed(
      context,
      AppRoutes.pokemonDetail,
      arguments: {'id': pokemonId},
    );
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
    String field = sortBy == HomeConstants.nameSortField ? 'name' : 'id';
    String direction = sortAscending ? 'asc' : 'desc';
    return [{field: direction}];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomeConstants.appTitle),
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
                  onTypeChanged: (value) => setState(() => selectedType = value ?? ''),
                  onGenerationChanged: (value) => setState(() => selectedGeneration = value ?? 0),
                  onSortTypeChanged: (index) => setState(() {
                    sortBy = index == 0 ? HomeConstants.defaultSortField : HomeConstants.nameSortField;
                  }),
                  onSortDirectionChanged: () => setState(() => sortAscending = !sortAscending),
                ),
              ],
            ),
          ),
          Expanded(
            child: Query(
              options: QueryOptions(
                document: gql(PokemonQueries.fetchPokemonList),
                variables: {
                  'limit': HomeConstants.pageLimit,
                  'offset': 0,
                  'where': _buildWhereClause(),
                  'orderBy': _buildOrderBy(),
                },
              ),
              builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
                return PokemonList(
                  result: result,
                  onPokemonTap: _navigateToPokemonDetail,
                  fetchMore: fetchMore,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}