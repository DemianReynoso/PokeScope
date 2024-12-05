# PokeScope

Una aplicación móvil desarrollada con Flutter que trae todo el mundo Pokémon a la palma de tu mano. Utilizando la potencia de la PokeAPI GraphQL, esta Pokédex moderna ofrece una experiencia fluida y completa para explorar el universo Pokémon.

## Características

- **Lista de Pokémon**: Visualización de todos los Pokémon con sus características básicas.
- **Filtros**: 
  - Por tipo de Pokémon
  - Por generación
  - Por habilidad (con autocompletado)
  - Ordenamiento por ID/Nombre
  - Filtro de favoritos
  - Para acceder a todos ellos, deslizar a la derecha la barra de filtros
- **Detalles del Pokémon**:
  - Información general (tipo, altura, peso)
  - Estadísticas base
  - Habilidades
  - Cadena evolutiva
  - Movimientos aprendibles (por nivel, MT/MO, tutor, huevo)
- **Favoritos**: Permite marcar y guardar Pokémon favoritos
- **Compartir**: Función para compartir "cartas" de Pokémon personalizadas

## Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo
- **GraphQL**: Para consultas a la PokeAPI
- **SharedPreferences**: Almacenamiento local para favoritos
- **Dart**: Lenguaje de programación base

## Paquetes Principales

- `graphql_flutter`: Integración con PokeAPI GraphQL
- `share_plus`: Funcionalidad de compartir
- `shared_preferences`: Almacenamiento local

## Estructura del Proyecto

```
lib/
├── constants/        # Constantes y configuraciones
├── pages/           # Pantallas de la aplicación
│   ├── home/        # Página principal
│   └── pokemon_detail/  # Detalles del Pokémon
├── providers/       # Gestión de estado
├── services/        # Servicios (compartir, etc.)
├── widgets/         # Widgets reutilizables
└── utils/          # Utilidades y helpers
```

## Características Destacadas

### Navegación Intuitiva
- Scroll infinito en la lista principal
- Navegación entre Pokémon mediante flechas
- Filtros y búsqueda en tiempo real

### Personalización
- Temas dinámicos basados en el tipo de Pokémon
- Tarjetas compartibles personalizadas
- Gestión de favoritos persistente

### Movimientos Detallados
- **Organización por Método**:
  - Aprendizaje por nivel
  - Máquinas (MT/MO)
  - Movimientos de tutor
  - Movimientos huevo
- Información detallada:
  - Poder
  - Precisión
  - PP
  - Tipo de movimiento

### Sistema de Compartir
- **Tarjetas Personalizadas**: Genera una tarjeta visual con la información del Pokémon
- **Contenido de la Tarjeta**:
  - Nombre y número del Pokémon
  - Imagen oficial
  - Tipos
  - Estadísticas base
  - Descripción
- **Compatibilidad**: Comparte a través de cualquier aplicación que soporte compartir imágenes
- **Formato**: La tarjeta se genera como imagen PNG para máxima compatibilidad

## Capturas de Pantalla
![image](https://github.com/user-attachments/assets/a36a8ff7-afe3-455f-a2f3-76bb61ed0ad8) ![image](https://github.com/user-attachments/assets/5a20ccef-4211-41cb-b921-7681c2f02188)

## Configuración del Proyecto

1. Clonar el repositorio
2. Instalar dependencias:
```bash
flutter pub get
```
3. Ejecutar la aplicación:
```bash
flutter run
```
