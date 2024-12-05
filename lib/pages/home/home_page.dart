import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../constants/pokemon_constants.dart';
import '../../providers/pokemon_favorites_provider.dart';
import '../../queries/pokemon_queries.dart';
import '../../routes/app_routes.dart';
import 'widgets/pokemon_search_bar.dart';
import 'widgets/filter_bar.dart';
import 'widgets/pokemon_list.dart';

class HomePage extends StatefulWidget {
  final PokemonFavoritesProvider favoritesProvider;

  const HomePage({
    super.key,
    required this.favoritesProvider
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String selectedType = '';
  int selectedGeneration = 0;
  String selectedAbility = '';
  String sortBy = HomeConstants.defaultSortField;
  bool sortAscending = true;
  bool showOnlyFavorites = false;

  void _navigateToPokemonDetail(BuildContext context, int pokemonId) {
    Navigator.pushNamed(
      context,
      AppRoutes.pokemonDetail,
      arguments: {'id': pokemonId},
    );
  }

  Map<String, dynamic> _buildWhereClause() {
    Map<String, dynamic> where = {};

    if (showOnlyFavorites) {
      where['id'] = {'_in': widget.favoritesProvider.currentFavorites.toList()};
    }

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

    if (selectedAbility.isNotEmpty) {
      where['pokemon_v2_pokemonabilities'] = {
        'pokemon_v2_ability': {
          'name': {'_eq': selectedAbility}
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
      backgroundColor: HomeConstants.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: HomeConstants.appBarElevation,
        backgroundColor: HomeConstants.appBarColor,
        title: const Text(
          HomeConstants.appTitle,
          style: TextStyle(
            color: HomeConstants.appBarTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                PokemonSearchBar(
                  searchQuery: searchQuery,
                  onSearchChanged: (value) => setState(() => searchQuery = value),
                ),
                const SizedBox(height: 12),
                FilterBar(
                  selectedType: selectedType,
                  selectedGeneration: selectedGeneration,
                  selectedAbility: selectedAbility,
                  sortBy: sortBy,
                  sortAscending: sortAscending,
                  showOnlyFavorites: showOnlyFavorites,
                  onTypeChanged: (value) => setState(() => selectedType = value ?? ''),
                  onGenerationChanged: (value) => setState(() => selectedGeneration = value ?? 0),
                  onAbilityChanged: (value) => setState(() => selectedAbility = value ?? ''),
                  onSortTypeChanged: (index) => setState(() {
                    sortBy = index == 0 ? HomeConstants.defaultSortField : HomeConstants.nameSortField;
                  }),
                  onSortDirectionChanged: () => setState(() => sortAscending = !sortAscending),
                  onFavoritesToggle: () => setState(() => showOnlyFavorites = !showOnlyFavorites),
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
                  favoritesProvider: widget.favoritesProvider,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}