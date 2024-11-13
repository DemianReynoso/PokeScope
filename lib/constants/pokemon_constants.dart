import 'package:flutter/material.dart';

class PokemonConstants {
  // Colores de tipos
  static const Map<String, Color> typeColors = {
    'normal': Colors.grey,
    'fire': Colors.red,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.yellow,
    'ice': Colors.lightBlueAccent,
    'fighting': Colors.brown,
    'poison': Colors.purple,
    'ground': Colors.brown,
    'flying': Colors.lightBlue,
    'psychic': Colors.pink,
    'bug': Colors.lightGreen,
    'rock': Colors.brown,
    'ghost': Colors.deepPurple,
    'dragon': Colors.indigo,
    'dark': Colors.black,
    'steel': Colors.blueGrey,
    'fairy': Colors.pinkAccent,
  };

  // Generaciones disponibles
  static const List<int> generations = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  // Títulos de secciones
  static const String evolutionChainTitle = 'Evolution Chain';
  static const String abilitiesTitle = 'Abilities';
  static const String baseStatsTitle = 'Base Stats';
  static const String hiddenAbilityText = 'Hidden';

  // Etiquetas de métricas
  static const String heightLabel = 'Height';
  static const String weightLabel = 'Weight';

  // Límites de stats para colores
  static const int lowStatThreshold = 50;
  static const int mediumStatThreshold = 90;
  static const int maxStatValue = 255;
}

class HomeConstants {
  static const String appTitle = 'Pokedex';
  static const int pageLimit = 50;
  static const String defaultSortField = 'id';
  static const String nameSortField = 'name';
}

class FilterBarConstants {
  static const String typeHint = 'Type';
  static const String allTypesLabel = 'All Types';
  static const String generationHint = 'Generation';
  static const String allGensLabel = 'All Gens';
  static const String genPrefix = 'Gen';
  static const String idSort = '#';
  static const String nameSort = 'A-Z';
}

class PokemonListConstants {
  static const String noResultsMessage = 'No Pokemon found with current filters';
}