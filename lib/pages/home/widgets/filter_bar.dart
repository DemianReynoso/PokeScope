import 'package:flutter/material.dart';
import '../../../constants/pokemon_constants.dart';
import '../../../utils/string_utils.dart';

class FilterBar extends StatelessWidget {
  final String selectedType;
  final int selectedGeneration;
  final String sortBy;
  final bool sortAscending;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<int?> onGenerationChanged;
  final ValueChanged<int> onSortTypeChanged;
  final VoidCallback onSortDirectionChanged;

  const FilterBar({
    super.key,
    required this.selectedType,
    required this.selectedGeneration,
    required this.sortBy,
    required this.sortAscending,
    required this.onTypeChanged,
    required this.onGenerationChanged,
    required this.onSortTypeChanged,
    required this.onSortDirectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTypeDropdown(),
          const SizedBox(width: 8),
          _buildGenerationDropdown(),
          const SizedBox(width: 8),
          _buildSortToggle(),
          const SizedBox(width: 8),
          _buildSortDirectionButton(),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown() {
    final types = PokemonConstants.typeColors.keys.toList();

    return DropdownButton<String>(
      value: selectedType.isEmpty ? null : selectedType,
      hint: Text(FilterBarConstants.typeHint),
      items: [
        DropdownMenuItem(
          value: '',
          child: Text(FilterBarConstants.allTypesLabel),
        ),
        ...types.map((type) => DropdownMenuItem(
          value: type,
          child: Text(StringUtils.capitalize(type)),
        )),
      ],
      onChanged: onTypeChanged,
    );
  }

  Widget _buildGenerationDropdown() {
    return DropdownButton<int>(
      value: selectedGeneration == 0 ? null : selectedGeneration,
      hint: Text(FilterBarConstants.generationHint),
      items: [
        DropdownMenuItem(
          value: 0,
          child: Text(FilterBarConstants.allGensLabel),
        ),
        ...PokemonConstants.generations.map((gen) => DropdownMenuItem(
          value: gen,
          child: Text('${FilterBarConstants.genPrefix} $gen'),
        )),
      ],
      onChanged: onGenerationChanged,
    );
  }

  Widget _buildSortToggle() {
    return ToggleButtons(
      isSelected: [
        sortBy == HomeConstants.defaultSortField,
        sortBy == HomeConstants.nameSortField
      ],
      onPressed: onSortTypeChanged,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(FilterBarConstants.idSort),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(FilterBarConstants.nameSort),
        ),
      ],
    );
  }

  Widget _buildSortDirectionButton() {
    return IconButton(
      icon: Icon(
        sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
      ),
      onPressed: onSortDirectionChanged,
    );
  }
}