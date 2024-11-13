import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../constants/pokemon_constants.dart';
import 'pokemon_card.dart';

class PokemonList extends StatelessWidget {
  final QueryResult result;
  final Function(BuildContext, int) onPokemonTap;

  const PokemonList({
    super.key,
    required this.result,
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
      return Center(
        child: Text(PokemonListConstants.noResultsMessage),
      );
    }

    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return PokemonCard(
          pokemon: pokemons[index],
          onTap: onPokemonTap,
        );
      },
    );
  }
}