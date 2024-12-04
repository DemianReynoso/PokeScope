import 'package:flutter/material.dart';

class PokemonMovesTable extends StatefulWidget {
  final List<dynamic> moves;
  final Color backgroundColor;
  final Color textColor;
  final Color titleColor;

  const PokemonMovesTable({
    Key? key,
    required this.moves,
    required this.backgroundColor,
    required this.textColor,
    required this.titleColor,
  }) : super(key: key);

  @override
  State<PokemonMovesTable> createState() => _PokemonMovesTableState();
}

class _PokemonMovesTableState extends State<PokemonMovesTable> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['Por nivel', 'MT/MO', 'Tutor', 'Huevo'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<dynamic> _filterMovesByMethod(String method) {
    // Creamos un Map para mantener un registro de los movimientos ya procesados
    final processedMoves = <String, dynamic>{};

    return widget.moves.where((move) {
      final learnMethod = move['pokemon_v2_movelearnmethod']['name'];
      final moveName = move['pokemon_v2_move']['name'];

      // Si el método no coincide, lo excluimos
      bool shouldInclude = false;
      switch (method) {
        case 'Por nivel':
          shouldInclude = learnMethod == 'level-up';
          break;
        case 'MT/MO':
          shouldInclude = learnMethod == 'machine';
          break;
        case 'Tutor':
          shouldInclude = learnMethod == 'tutor';
          break;
        case 'Huevo':
          shouldInclude = learnMethod.contains('egg');
          break;
        default:
          shouldInclude = false;
      }

      if (!shouldInclude) return false;

      // Si ya procesamos este movimiento para este método, lo excluimos
      final moveKey = '$moveName-$learnMethod';
      if (processedMoves.containsKey(moveKey)) {
        // Para movimientos por nivel, mantenemos el de nivel más bajo
        if (method == 'Por nivel') {
          final existingLevel = processedMoves[moveKey]['level'] ?? 0;
          final currentLevel = move['level'] ?? 0;
          if (currentLevel < existingLevel) {
            processedMoves[moveKey] = move;
            return true;
          }
        }
        return false;
      }

      // Si es un movimiento nuevo, lo guardamos y lo incluimos
      processedMoves[moveKey] = move;
      return true;
    }).toList()
      ..sort((a, b) {
        if (method == 'Por nivel') {
          return (a['level'] ?? 0).compareTo(b['level'] ?? 0);
        }
        return a['pokemon_v2_move']['name'].compareTo(b['pokemon_v2_move']['name']);
      });
  }

  Widget _buildMoveTable(List<dynamic> moves) {
    return SingleChildScrollView(
      child: Container(
        color: widget.backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(widget.backgroundColor.withOpacity(0.7)),
            columns: [
              if (_tabController.index == 0)
                DataColumn(
                    label: Text('Nivel', style: TextStyle(color: widget.titleColor, fontWeight: FontWeight.bold))
                ),
              DataColumn(
                  label: Text('Movimiento', style: TextStyle(color: widget.titleColor, fontWeight: FontWeight.bold))
              ),
              DataColumn(
                  label: Text('Tipo', style: TextStyle(color: widget.titleColor, fontWeight: FontWeight.bold))
              ),
              DataColumn(
                  label: Text('Poder', style: TextStyle(color: widget.titleColor, fontWeight: FontWeight.bold))
              ),
              DataColumn(
                  label: Text('Precisión', style: TextStyle(color: widget.titleColor, fontWeight: FontWeight.bold))
              ),
              DataColumn(
                  label: Text('PP', style: TextStyle(color: widget.titleColor, fontWeight: FontWeight.bold))
              ),
            ],
            rows: moves.map((move) {
              final moveData = move['pokemon_v2_move'];
              return DataRow(
                cells: [
                  if (_tabController.index == 0)
                    DataCell(Text(
                      '${move['level']}',
                      style: TextStyle(color: widget.textColor),
                    )),
                  DataCell(Text(
                    moveData['name'],
                    style: TextStyle(color: widget.textColor),
                  )),
                  DataCell(Text(
                    moveData['pokemon_v2_type']['name'],
                    style: TextStyle(color: widget.textColor),
                  )),
                  DataCell(Text(
                    moveData['power']?.toString() ?? '-',
                    style: TextStyle(color: widget.textColor),
                  )),
                  DataCell(Text(
                    moveData['accuracy']?.toString() ?? '-',
                    style: TextStyle(color: widget.textColor),
                  )),
                  DataCell(Text(
                    moveData['pp'].toString(),
                    style: TextStyle(color: widget.textColor),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Movimientos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: widget.titleColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: _categories.map((category) {
                  final movesCount = _filterMovesByMethod(category).length;
                  return Tab(
                    child: Text(
                      '$category ($movesCount)',
                      style: TextStyle(color: widget.textColor),
                    ),
                  );
                }).toList(),
                indicatorColor: widget.titleColor,
                isScrollable: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 400, // Aumenté la altura para mostrar más movimientos
                child: TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) {
                    final filteredMoves = _filterMovesByMethod(category);
                    return filteredMoves.isEmpty
                        ? Center(
                      child: Text(
                        'No hay movimientos disponibles',
                        style: TextStyle(color: widget.textColor),
                      ),
                    )
                        : _buildMoveTable(filteredMoves);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}