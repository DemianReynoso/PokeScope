class PokemonQueries {
  // Query para la página principal
  static const String fetchPokemonList = """
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

  // Query para la página de detalles
  static const String fetchPokemonDetails = """
query getPokemonDetails(\$pokemonId: Int!) {
  pokemon_v2_pokemon_by_pk(id: \$pokemonId) {
    id
    name
    height
    weight
    pokemon_v2_pokemonsprites {
      sprites(path: "other.official-artwork.front_default")
    }
    pokemon_v2_pokemontypes {
      pokemon_v2_type {
        name
      }
    }
    pokemon_v2_pokemonabilities {
      pokemon_v2_ability {
        name
        pokemon_v2_abilityflavortexts(where: {language_id: {_eq: 9}}, limit: 1) {
          flavor_text
        }
      }
      is_hidden
    }
    pokemon_v2_pokemonmoves(distinct_on: [move_id, move_learn_method_id]) {
      level
      move_id
      move_learn_method_id
      version_group_id
      pokemon_v2_move {
        name
        power
        accuracy
        pp
        pokemon_v2_moveflavortexts(where: {language_id: {_eq: 9}}, limit: 1) {
          flavor_text
        }
        pokemon_v2_type {
          name
        }
      }
      pokemon_v2_movelearnmethod {
        name
      }
    }
    pokemon_v2_pokemonstats {
      base_stat
      pokemon_v2_stat {
        name
      }
    }
    pokemon_v2_pokemonspecy {
      pokemon_v2_pokemonspeciesflavortexts(where: {language_id: {_eq: 9}}, limit: 1) {
        flavor_text
      }
      evolution_chain_id
    }
  }
  pokemon_v2_evolutionchain(where: {pokemon_v2_pokemonspecies: {pokemon_v2_pokemons: {id: {_eq: \$pokemonId}}}}) {
    pokemon_v2_pokemonspecies {
      name
      id
      evolves_from_species_id
      pokemon_v2_pokemonevolutions {
        min_level
        pokemon_v2_evolutiontrigger {
          name
        }
      }
      pokemon_v2_pokemons {
        pokemon_v2_pokemonsprites {
          sprites(path: "other.official-artwork.front_default")
        }
        pokemon_v2_pokemontypes {
          pokemon_v2_type {
            name
          }
        }
      }
    }
  }
  max_id: pokemon_v2_pokemon(order_by: {id: desc}, limit: 1) {
    id
  }
}
""";
}