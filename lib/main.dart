import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'pages/home/home_page.dart';

void main() async {
  await initHiveForFlutter(); // Inicializa Hive para el almacenamiento en cache
  final HttpLink httpLink = HttpLink('https://beta.pokeapi.co/graphql/v1beta'); // Enlace a la PokeAPI GraphQL

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()), // Configuración de cache
    ),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Pokedex',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}