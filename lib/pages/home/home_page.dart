import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String selectedType = '';
  int selectedGeneration = 0;
  String sortBy = 'id'; // 'id' o 'name'
  bool sortAscending = true;

  // Actualizamos la consulta para incluir filtros
  final String fetchPokemonQuery = """
  query getPokemonForHomepage(
    \$limit: Int, 
    \$offset: Int,
    \$where: pokemon_v2_pokemon_bool_exp,
    \$orderBy: [pokemon_v2_pokemon_order_by!]
  ) {
    pokemon_v2_pokemon(
      limit: \$limit, 
      offset: \$offset,
      where: \$where,
      order_by: \$orderBy
    ) {
      id
      name
      pokemon_v2_pokemonsprites {
        sprites(path: "other.official-artwork.front_default")
      }
      pokemon_v2_pokemontypes {
        pokemon_v2_type {
          name
        }
      }
      pokemon_v2_pokemonspecy {
        generation_id
      }
    }
  }
  """;

  static const Map<String, Color> pokemonTypeColors = {
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

  List<String> get pokemonTypes => pokemonTypeColors.keys.toList();

  final List<int> generations = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  void _navigateToPokemonDetail(BuildContext context, int pokemonId) {
    Navigator.pushNamed(
      context,
      AppRoutes.pokemonDetail,
      arguments: {'id': pokemonId},
    );
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Map<String, dynamic> _buildWhereClause() {
    Map<String, dynamic> where = {};

    // Filtro por nombre
    if (searchQuery.isNotEmpty) {
      where['name'] = {'_ilike': '%$searchQuery%'};
    }

    // Filtro por tipo
    if (selectedType.isNotEmpty) {
      where['pokemon_v2_pokemontypes'] = {
        'pokemon_v2_type': {
          'name': {'_eq': selectedType}
        }
      };
    }

    // Filtro por generación
    if (selectedGeneration > 0) {
      where['pokemon_v2_pokemonspecy'] = {
        'generation_id': {'_eq': selectedGeneration}
      };
    }

    return where;
  }

  List<Map<String, dynamic>> _buildOrderBy() {
    String field = sortBy == 'name' ? 'name' : 'id';
    String direction = sortAscending ? 'asc' : 'desc';
    return [{field: direction}];
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Pokemon...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
          ),
          const SizedBox(height: 8),
          // Filtros y ordenamiento
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Dropdown de tipos
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
                  onChanged: (value) => setState(() => selectedType = value ?? ''),
                ),
                const SizedBox(width: 8),
                // Dropdown de generaciones
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
                  onChanged: (value) => setState(() => selectedGeneration = value ?? 0),
                ),
                const SizedBox(width: 8),
                // Botones de ordenamiento
                ToggleButtons(
                  isSelected: [sortBy == 'id', sortBy == 'name'],
                  onPressed: (index) => setState(() {
                    sortBy = index == 0 ? 'id' : 'name';
                  }),
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
                  onPressed: () => setState(() => sortAscending = !sortAscending),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String type, Color typeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: typeColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        capitalize(type),
        style: TextStyle(
          fontSize: 14,
          color: typeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Query(
              options: QueryOptions(
                document: gql(fetchPokemonQuery),
                variables: {
                  'limit': 50,
                  'offset': 0,
                  'where': _buildWhereClause(),
                  'orderBy': _buildOrderBy(),
                },
              ),
              builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (result.hasException) {
                  return Center(child: Text(result.exception.toString()));
                }

                final pokemons = result.data?['pokemon_v2_pokemon'] ?? [];

                if (pokemons.isEmpty) {
                  return const Center(
                    child: Text('No Pokemon found with current filters'),
                  );
                }

                return ListView.builder(
                  itemCount: pokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = pokemons[index];
                    final name = capitalize(pokemon['name']);
                    final types = pokemon['pokemon_v2_pokemontypes'];
                    final primaryType = types[0]['pokemon_v2_type']['name'];
                    final secondaryType = types.length > 1 ? types[1]['pokemon_v2_type']['name'] : null;
                    final spriteUrl = pokemon['pokemon_v2_pokemonsprites'][0]['sprites'];

                    return InkWell(
                      onTap: () => _navigateToPokemonDetail(context, pokemon['id']),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: pokemonTypeColors[primaryType]?.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: pokemonTypeColors[primaryType] ?? Colors.grey),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              spriteUrl ?? '',
                              height: 80,
                              width: 80,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Center(child: Icon(Icons.error)),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildTypeChip(
                                        primaryType,
                                        pokemonTypeColors[primaryType] ?? Colors.grey,
                                      ),
                                      if (secondaryType != null) ...[
                                        const SizedBox(width: 8),
                                        _buildTypeChip(
                                          secondaryType,
                                          pokemonTypeColors[secondaryType] ?? Colors.grey,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}