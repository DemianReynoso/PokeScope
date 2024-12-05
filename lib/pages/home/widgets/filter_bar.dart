import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../constants/pokemon_constants.dart';

class AbilitySearchField extends StatelessWidget {
  final String selectedAbility;
  final Function(String?) onAbilityChanged;

  const AbilitySearchField({
    Key? key,
    required this.selectedAbility,
    required this.onAbilityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql('''
          query getAbilities {
            pokemon_v2_ability(where: {pokemon_v2_abilitynames: {language_id: {_eq: 9}}}) {
              name
            }
          }
        '''),
      ),
      builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return const Text('Error al cargar habilidades');
        }

        if (result.isLoading) {
          return const CircularProgressIndicator();
        }

        final abilities = result.data?['pokemon_v2_ability'] as List<dynamic>;
        final sortedAbilities = abilities
            .map((ability) => ability['name'] as String)
            .toList()
          ..sort();

        return Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Autocomplete<String>(
            initialValue: TextEditingValue(text: selectedAbility),
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return sortedAbilities.where((ability) =>
                  ability.toLowerCase().contains(textEditingValue.text.toLowerCase())
              );
            },
            onSelected: onAbilityChanged,
            fieldViewBuilder: (
                BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
                ) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Buscar habilidad',
                  border: InputBorder.none,
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                      onAbilityChanged('');
                    },
                  )
                      : null,
                ),
                onFieldSubmitted: (String value) {
                  if (sortedAbilities.contains(value)) {
                    onAbilityChanged(value);
                  }
                },
              );
            },
            optionsViewBuilder: (
                BuildContext context,
                void Function(String) onSelected,
                Iterable<String> options,
                ) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  child: Container(
                    width: 200,
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ability = options.elementAt(index);
                        return ListTile(
                          title: Text(ability),
                          onTap: () => onSelected(ability),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class FilterBar extends StatelessWidget {
  final String selectedType;
  final int selectedGeneration;
  final String selectedAbility;
  final String sortBy;
  final bool sortAscending;
  final bool showOnlyFavorites;
  final Function(String?) onTypeChanged;
  final Function(int?) onGenerationChanged;
  final Function(String?) onAbilityChanged;
  final Function(int) onSortTypeChanged;
  final Function() onSortDirectionChanged;
  final Function() onFavoritesToggle;

  const FilterBar({
    Key? key,
    required this.selectedType,
    required this.selectedGeneration,
    required this.selectedAbility,
    required this.sortBy,
    required this.sortAscending,
    required this.showOnlyFavorites,
    required this.onTypeChanged,
    required this.onGenerationChanged,
    required this.onAbilityChanged,
    required this.onSortTypeChanged,
    required this.onSortDirectionChanged,
    required this.onFavoritesToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Filtro de Tipos
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedType.isEmpty ? null : selectedType,
                hint: const Text('Tipo'),
                items: [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('Todos los tipos'),
                  ),
                  ...PokemonConstants.typeColors.keys.map(
                        (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ),
                  ),
                ],
                onChanged: onTypeChanged,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Filtro de Generaciones
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedGeneration == 0 ? null : selectedGeneration,
                hint: const Text('Generación'),
                items: [
                  const DropdownMenuItem(
                    value: 0,
                    child: Text('Todas las generaciones'),
                  ),
                  for (var i = 1; i <= 9; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text('Generación $i'),
                    ),
                ],
                onChanged: onGenerationChanged,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Campo de búsqueda de habilidades
          AbilitySearchField(
            selectedAbility: selectedAbility,
            onAbilityChanged: onAbilityChanged,
          ),
          const SizedBox(width: 8),
          // Botones de ordenamiento
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: sortBy == HomeConstants.defaultSortField ? 0 : 1,
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Ordenar por #'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('Ordenar por nombre'),
                      ),
                    ],
                    onChanged: (value) => onSortTypeChanged(value ?? 0),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                  ),
                  onPressed: onSortDirectionChanged,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Botón de favoritos
          Container(
            decoration: BoxDecoration(
              color: showOnlyFavorites ? Colors.red[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: showOnlyFavorites ? Colors.red[700] : Colors.grey[600],
              ),
              onPressed: onFavoritesToggle,
            ),
          ),
        ],
      ),
    );
  }
}