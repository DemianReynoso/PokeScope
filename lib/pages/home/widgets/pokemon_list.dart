import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'pokemon_card.dart';

class PokemonList extends StatelessWidget {
  final QueryResult result;
  final Map<String, Color> typeColors;
  final String Function(String) capitalize;
  final Function(BuildContext, int) onPokemonTap;

  const PokemonList({
    super.key,
    required this.result,
    required this.typeColors,
    required this.capitalize,
    required this.onPokemonTap,
  });

  @override
  Widget build(BuildContext context) {
    if (result.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (result.hasException) {
      return Center(child: Text(result.exception.toString()));
    }

    final pokemons = result.data?['pokemon_v2_pokemon'] ?? [];

    if (pokemons.isEmpty) {
      return const Center(
        child: Text('No Pokemon found with current filters'),
      );
    }

    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return PokemonCard(
          pokemon: pokemons[index],
          typeColors: typeColors,
          capitalize: capitalize,
          onTap: onPokemonTap,
        );
      },
    );
  }
}