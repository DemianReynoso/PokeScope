class StringUtils {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatPokemonId(int id) {
    return '#${id.toString().padLeft(3, '0')}';
  }

  static String formatWeight(int weight) {
    return '${(weight / 10).toStringAsFixed(1)} kg';
  }

  static String formatHeight(int height) {
    return '${(height / 10).toStringAsFixed(1)} m';
  }

  static String formatEvolutionTrigger(Map<String, dynamic> evolution) {
    final triggerName = evolution['pokemon_v2_evolutiontrigger']['name'];
    final level = evolution['min_level'];

    if (triggerName == 'level-up' && level != null) {
      return 'Lvl $level';
    }

    return triggerName.replaceAll('-', ' ');
  }
}