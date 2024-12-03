import 'package:flutter/material.dart';

import '../providers/pokemon_favorites_provider.dart';

class FavoriteButton extends StatefulWidget {
  final int pokemonId;
  final bool initialValue;
  final Function(int) onToggle;
  final Color? color;
  final PokemonFavoritesProvider favoritesProvider;  // Añadir esto

  const FavoriteButton({
    super.key,
    required this.pokemonId,
    required this.initialValue,
    required this.onToggle,
    required this.favoritesProvider,  // Y esto
    this.color,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFavorite() async {
    await widget.onToggle(widget.pokemonId);
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<int>>(
      stream: widget.favoritesProvider.favoritesStream,
      initialData: widget.favoritesProvider.currentFavorites,
      builder: (context, snapshot) {
        final isFavorite = snapshot.data?.contains(widget.pokemonId) ?? false;

        return ScaleTransition(
          scale: _scaleAnimation,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.color ?? Colors.red,
            ),
            onPressed: () {
              widget.onToggle(widget.pokemonId);
              if (isFavorite) {
                _controller.forward().then((_) => _controller.reverse());
              }
            },
          ),
        );
      },
    );
  }
}