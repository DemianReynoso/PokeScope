import 'package:flutter/material.dart';
import 'package:my_pokedex/providers/pokemon_favorites_provider.dart';
import '../pages/home/home_page.dart';
import '../pages/pokemon_detail/pokemon_detail_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String pokemonDetail = '/pokemon-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings, PokemonFavoritesProvider provider) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => HomePage(favoritesProvider: provider,),
        );

      case pokemonDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PokemonDetailPage(
            pokemonId: args['id'] as int,
            favoritesProvider: provider, // Pasar el provider instanciado
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Ruta no encontrada'),
            ),
          ),
        );
    }
  }
}