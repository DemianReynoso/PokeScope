import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final int pokemonId;
  final bool initialValue;
  final Function(int) onToggle;
  final Color? color;

  const FavoriteButton({
    super.key,
    required this.pokemonId,
    required this.initialValue,
    required this.onToggle,
    this.color,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late bool isFavorite;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialValue;
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
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      _controller.forward().then((_) => _controller.reverse());
    }

    widget.onToggle(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.color ?? Colors.red,
        ),
        onPressed: _toggleFavorite,
      ),
    );
  }
}