import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../constants/pokemon_constants.dart';
import 'pokemon_card.dart';

class PokemonList extends StatefulWidget {
  final QueryResult result;
  final Function(BuildContext, int) onPokemonTap;
  final FetchMore? fetchMore;

  const PokemonList({
    super.key,
    required this.result,
    required this.onPokemonTap,
    this.fetchMore,
  });

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0; // Cargar más cuando falten 200 pixels para llegar al final

    if (maxScroll - currentScroll <= threshold) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (widget.fetchMore == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    final currentPokemons = widget.result.data?['pokemon_v2_pokemon'] as List?;
    if (currentPokemons == null) return;

    await widget.fetchMore?.call(FetchMoreOptions(
      variables: {
        'offset': currentPokemons.length,
        'limit': HomeConstants.pageLimit,
      },
      updateQuery: (previousResultData, fetchMoreResultData) {
        if (fetchMoreResultData == null) return previousResultData;

        final List<dynamic> newPokemons = [
          ...previousResultData?['pokemon_v2_pokemon'] as List? ?? [],
          ...fetchMoreResultData['pokemon_v2_pokemon'] as List? ?? [],
        ];

        return {
          ...previousResultData!,
          'pokemon_v2_pokemon': newPokemons,
        };
      },
    ));

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.result.isLoading && widget.result.data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.result.hasException) {
      return const Center(child: Text(PokemonListConstants.noResultsMessage));
    }

    final pokemons = widget.result.data?['pokemon_v2_pokemon'] as List? ?? [];

    if (pokemons.isEmpty) {
      return const Center(
        child: Text(PokemonListConstants.noResultsMessage),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: pokemons.length + 1, // +1 para el indicador de carga
      itemBuilder: (context, index) {
        if (index == pokemons.length) {
          return _isLoadingMore
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
              : const SizedBox.shrink();
        }

        return PokemonCard(
          pokemon: pokemons[index],
          onTap: widget.onPokemonTap,
        );
      },
    );
  }
}