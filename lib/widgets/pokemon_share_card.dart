import 'package:flutter/material.dart';
import '../../../utils/string_utils.dart';
import '../../../constants/pokemon_constants.dart';

class PokemonShareCard extends StatelessWidget {
  static final GlobalKey cardKey = GlobalKey();
  final Map<String, dynamic> pokemon;
  final Color primaryColor;

  const PokemonShareCard({
    super.key,
    required this.pokemon,
    required this.primaryColor,
  });

  Widget _buildStats(List<dynamic> stats, Color barColor, Color backgroundColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stats.map((stat) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                stat['pokemon_v2_stat']['name'].toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              stat['base_stat'].toString().padLeft(3),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: stat['base_stat'] / 255,
                  backgroundColor: backgroundColor,
                  color: barColor,
                  minHeight: 8,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = StringUtils.capitalize(pokemon['name']);
    final types = pokemon['pokemon_v2_pokemontypes'];
    final spriteUrl = pokemon['pokemon_v2_pokemonsprites'][0]['sprites'];
    final stats = pokemon['pokemon_v2_pokemonstats'];
    final description = pokemon['pokemon_v2_pokemonspecy']
    ['pokemon_v2_pokemonspeciesflavortexts'][0]['flavor_text'];

    return RepaintBoundary(
      key: PokemonShareCard.cardKey,  // Usar la key estática
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con nombre y número
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  '#${pokemon['id'].toString().padLeft(3, '0')}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Imagen del Pokémon
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.network(
                spriteUrl,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),

            // Tipos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: types.map<Widget>((type) {
                final typeName = type['pokemon_v2_type']['name'];
                final typeColor = PokemonConstants.typeColors[typeName]!;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: typeColor),
                  ),
                  child: Text(
                    StringUtils.capitalize(typeName),
                    style: TextStyle(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Descripción
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Text(
                description.replaceAll('\n', ' '),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Stats
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    'Base Stats',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStats(
                    stats,
                    primaryColor,
                    primaryColor.withOpacity(0.2),
                    Colors.grey[800]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}