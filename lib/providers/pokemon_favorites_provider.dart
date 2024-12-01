import 'package:shared_preferences/shared_preferences.dart';

class PokemonFavoritesProvider {
  static const String _favoritesKey = 'pokemon_favorites';
  final SharedPreferences _prefs;

  PokemonFavoritesProvider(this._prefs);

  // Obtener lista de favoritos
  Future<Set<int>> getFavorites() async {
    final favorites = _prefs.getStringList(_favoritesKey);
    if (favorites == null) return {};
    return favorites.map((id) => int.parse(id)).toSet();
  }

  // Añadir a favoritos
  Future<bool> addFavorite(int pokemonId) async {
    final favorites = await getFavorites();
    favorites.add(pokemonId);
    return _prefs.setStringList(
      _favoritesKey,
      favorites.map((id) => id.toString()).toList(),
    );
  }

  // Eliminar de favoritos
  Future<bool> removeFavorite(int pokemonId) async {
    final favorites = await getFavorites();
    favorites.remove(pokemonId);
    return _prefs.setStringList(
      _favoritesKey,
      favorites.map((id) => id.toString()).toList(),
    );
  }

  // Comprobar si es favorito
  Future<bool> isFavorite(int pokemonId) async {
    final favorites = await getFavorites();
    return favorites.contains(pokemonId);
  }

  // Toggle favorito
  Future<bool> toggleFavorite(int pokemonId) async {
    if (await isFavorite(pokemonId)) {
      return removeFavorite(pokemonId);
    } else {
      return addFavorite(pokemonId);
    }
  }
}