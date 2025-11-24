import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/categorias/categorias_page.dart';
import '../presentation/pages/destinos/destinos_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/mapa/mapa_page.dart';
import '../presentation/pages/perfil/perfil_page.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _NavigationShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categorias',
                name: 'categorias',
                builder: (context, state) => const CategoriasPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/destinos',
                name: 'destinos',
                builder: (context, state) => const DestinosPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mapa',
                name: 'mapa',
                builder: (context, state) => const MapaPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/perfil',
                name: 'perfil',
                builder: (context, state) => const PerfilPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _NavigationShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _NavigationShellScaffold({required this.navigationShell});

  void _onDestinationSelected(int index) {
    if (index == navigationShell.currentIndex) return;
    final bool useInitialLocation = index == navigationShell.currentIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationShell.goBranch(
        index,
        initialLocation: useInitialLocation,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.category_outlined), label: 'Categorías'),
          NavigationDestination(icon: Icon(Icons.landscape_outlined), label: 'Destinos'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
        height: 72,
        backgroundColor: colors.surface.withOpacity(0.92),
        elevation: 4,
      ),
    );
  }
}
