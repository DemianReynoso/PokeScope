import 'package:flutter/material.dart';

class PokemonConstants {
  // Colores de tipos
  static const Map<String, Color> typeColors = {
    'normal': Color(0xFF9099A1),    // Gris neutro
    'fire': Color(0xFFFF9C54),      // Naranja fuego
    'water': Color(0xFF4D90D5),     // Azul agua
    'grass': Color(0xFF63BB5B),     // Verde hierba
    'electric': Color(0xFFF3D23B),  // Amarillo eléctrico
    'ice': Color(0xFF74CEC0),       // Azul hielo
    'fighting': Color(0xFFCE4069),  // Rojo lucha
    'poison': Color(0xFFAB6AC8),    // Morado veneno
    'ground': Color(0xFFD97746),    // Marrón tierra
    'flying': Color(0xFF8FA8DD),    // Azul celeste
    'psychic': Color(0xFFFA7179),   // Rosa psíquico
    'bug': Color(0xFF90C12C),       // Verde insecto
    'rock': Color(0xFFC7B78B),      // Marrón roca
    'ghost': Color(0xFF5269AC),     // Morado fantasma
    'dragon': Color(0xFF0A6DC4),    // Azul dragón
    'dark': Color(0xFF5A5366),      // Gris oscuro
    'steel': Color(0xFF5A8EA1),     // Azul acero
    'fairy': Color(0xFFEC8FE6),     // Rosa hada
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

class PokemonDetailStyles {
  // Containers
  static const double containerRadius = 12.0;
  static const double containerPadding = 16.0;
  static const double metricWidth = 120.0;
  static const double backgroundOpacity = 0.1;

  // Typography
  static const double descriptionFontSize = 14.0;
  static const double descriptionLineHeight = 1.5;
  static const double metricLabelSize = 14.0;
  static const double metricValueSize = 16.0;

  // Colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static final Color containerBackground = Colors.grey.withOpacity(backgroundOpacity);
}