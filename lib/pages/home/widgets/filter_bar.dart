import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String selectedType;
  final int selectedGeneration;
  final String sortBy;
  final bool sortAscending;
  final List<String> pokemonTypes;
  final List<int> generations;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<int?> onGenerationChanged;
  final ValueChanged<int> onSortTypeChanged;
  final VoidCallback onSortDirectionChanged;
  final String Function(String) capitalize;

  const FilterBar({
    super.key,
    required this.selectedType,
    required this.selectedGeneration,
    required this.sortBy,
    required this.sortAscending,
    required this.pokemonTypes,
    required this.generations,
    required this.onTypeChanged,
    required this.onGenerationChanged,
    required this.onSortTypeChanged,
    required this.onSortDirectionChanged,
    required this.capitalize,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          DropdownButton<String>(
            value: selectedType.isEmpty ? null : selectedType,
            hint: const Text('Type'),
            items: [
              const DropdownMenuItem(
                value: '',
                child: Text('All Types'),
              ),
              ...pokemonTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(capitalize(type)),
              )),
            ],
            onChanged: onTypeChanged,
          ),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: selectedGeneration == 0 ? null : selectedGeneration,
            hint: const Text('Generation'),
            items: [
              const DropdownMenuItem(
                value: 0,
                child: Text('All Gens'),
              ),
              ...generations.map((gen) => DropdownMenuItem(
                value: gen,
                child: Text('Gen $gen'),
              )),
            ],
            onChanged: onGenerationChanged,
          ),
          const SizedBox(width: 8),
          ToggleButtons(
            isSelected: [sortBy == 'id', sortBy == 'name'],
            onPressed: (index) => onSortTypeChanged(index),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('#'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('A-Z'),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            onPressed: onSortDirectionChanged,
          ),
        ],
      ),
    );
  }
}