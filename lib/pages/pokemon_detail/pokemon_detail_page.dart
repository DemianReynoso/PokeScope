import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_pokedex/pages/pokemon_detail/widgets/pokemon_moves_table.dart';
import '../../constants/pokemon_constants.dart';
import '../../providers/pokemon_favorites_provider.dart';
import '../../queries/pokemon_queries.dart';
import '../../routes/app_routes.dart';
import '../../services/share_services.dart';
import '../../widgets/favorite_button.dart';
import '../../widgets/pokemon_share_card.dart';
import 'widgets/pokemon_header.dart';
import 'widgets/pokemon_type_chip.dart';
import 'widgets/pokemon_metric.dart';
import 'widgets/pokemon_ability_card.dart';
import 'widgets/pokemon_stat_bar.dart';
import 'widgets/pokemon_evolution_chain.dart';

class PokemonDetailPage extends StatefulWidget {
  final int pokemonId;
  final PokemonFavoritesProvider favoritesProvider; // Añadir esta línea

  const PokemonDetailPage({
    super.key,
    required this.pokemonId,
    required this.favoritesProvider,
  });

  @override
  State<StatefulWidget>  createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  Set<int> _favorites = {};
  StreamSubscription? _subscription;  // Añadir esto
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkInitialFavoriteStatus();
  }

  Future<void> _checkInitialFavoriteStatus() async {
    final isFavorite = widget.favoritesProvider.isFavorite(widget.pokemonId);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }


  @override
  void dispose() {
    _subscription?.cancel();  // Cancelar la suscripción
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    if (!mounted) return;  // Verificar si está montado
    final favorites = await widget.favoritesProvider.getFavorites();
    if (mounted) {  // Verificar de nuevo
      setState(() {
        _favorites = favorites;
      });
    }
  }

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

  void _handlePokemonNavigation(BuildContext context, int pokemonId) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.pokemonDetail,
      arguments: {'id': pokemonId},
    );
  }

  void _showShareCard(BuildContext context, Map<String, dynamic> pokemon, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 24.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PokemonShareCard(
              pokemon: pokemon,
              primaryColor: primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await ShareService.shareCard(
                        PokemonShareCard.cardKey,
                        pokemon['name'],
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Compartir'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    return FutureBuilder<Set<int>>(
      future: widget.favoritesProvider.getFavorites(),
      builder: (context, snapshot) {
        return Query(
          options: QueryOptions(
            document: gql(PokemonQueries.fetchPokemonDetails),
            variables: {'pokemonId': widget.pokemonId},
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

            final maxId = result.data?['max_id'][0]['id'] as int;


            return Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                backgroundColor: backgroundColor,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _showShareCard(context, pokemon, primaryColor),
                    color: textColor,
                  ),
                  FavoriteButton(
                    pokemonId: pokemon['id'],
                    initialValue: _isFavorite,
                    onToggle: (id) async {
                      await widget.favoritesProvider.toggleFavorite(id);
                      if (mounted) {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      }
                    },
                    color: primaryColor,
                    favoritesProvider: widget.favoritesProvider,
                  ),
                  const SizedBox(width: 8),
                ],
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
                          PokemonMovesTable(
                            moves: pokemon['pokemon_v2_pokemonmoves'],
                            backgroundColor: containerColor,
                            textColor: textColor,
                            titleColor: titleColor,
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
              bottomNavigationBar: Container(
                color: backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 40,
                        icon: Icon(
                          Icons.arrow_left,
                          color: pokemon['id'] > 1 ? textColor : textColor.withOpacity(0.3),
                        ),
                        onPressed: pokemon['id'] > 1
                            ? () => _handlePokemonNavigation(context, pokemon['id'] - 1)
                            : null,
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: Icon(
                          Icons.arrow_right,
                          color: pokemon['id'] < maxId ? textColor : textColor.withOpacity(0.3),
                        ),
                        onPressed: pokemon['id'] < maxId
                            ? () => _handlePokemonNavigation(context, pokemon['id'] + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
