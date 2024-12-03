import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonFavoritesProvider {
  static const String _favoritesKey = 'pokemon_favorites';
  final SharedPreferences _prefs;
  final _favoritesController = StreamController<Set<int>>.broadcast();
  Set<int> _favorites = {};

  PokemonFavoritesProvider(this._prefs) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final List<String>? storedFavorites = _prefs.getStringList(_favoritesKey);
    if (storedFavorites != null) {
      _favorites = storedFavorites.map((id) => int.parse(id)).toSet();
    }
    _favoritesController.add(_favorites);
  }

  Future<Set<int>> getFavorites() async {
    final List<String>? storedFavorites = _prefs.getStringList(_favoritesKey);
    if (storedFavorites != null) {
      return storedFavorites.map((id) => int.parse(id)).toSet();
    }
    return {};
  }

  Stream<Set<int>> get favoritesStream => _favoritesController.stream;

  Set<int> get currentFavorites => Set.from(_favorites);

  Future<bool> toggleFavorite(int pokemonId) async {
    print('Toggling favorite for Pokemon: $pokemonId');
    print('Current favorites before toggle: $_favorites');

    if (_favorites.contains(pokemonId)) {
      _favorites.remove(pokemonId);
    } else {
      _favorites.add(pokemonId);
    }

    print('Favorites after toggle: $_favorites');

    final result = await _prefs.setStringList(
      _favoritesKey,
      _favorites.map((id) => id.toString()).toList(),
    );

    if (result) {
      print('Emitting new favorites through stream: $_favorites');
      _favoritesController.add(_favorites);
    }

    return result;
  }

  bool isFavorite(int pokemonId) {
    return _favorites.contains(pokemonId);
  }

  void dispose() {
    _favoritesController.close();
  }
}