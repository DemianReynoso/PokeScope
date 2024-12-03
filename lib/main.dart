import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_pokedex/providers/pokemon_favorites_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter(); // Inicializa Hive para el almacenamiento en cache
  final HttpLink httpLink = HttpLink('https://beta.pokeapi.co/graphql/v1beta'); // Enlace a la PokeAPI GraphQL
  final prefs = await SharedPreferences.getInstance();
  final favoritesProvider = PokemonFavoritesProvider(prefs);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()), // Configuración de cache
    ),
  );

  runApp(MyApp(
      client: client,
    favoritesProvider: favoritesProvider, // Añadir el provider

  ));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  final PokemonFavoritesProvider favoritesProvider;

  const MyApp({super.key, required this.client,
    required this.favoritesProvider});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Pokedex',
        theme: ThemeData(primarySwatch: Colors.blue),
        //home: const HomePage(),
        initialRoute: AppRoutes.home,
        onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(
          settings,
          favoritesProvider, // Pasar el provider a las rutas
        ),      ),
    );
  }
}