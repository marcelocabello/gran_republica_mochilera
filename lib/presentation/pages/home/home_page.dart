import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/destino_entity.dart';
import '../../../domain/usecases/get_destinos_usecase.dart';
import '../../widgets/app_bar_custom.dart';
import '../../widgets/card_item.dart';
import '../../widgets/common_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<DestinoEntity>> _destinosFuture;

  @override
  void initState() {
    super.initState();
    final useCase = context.read<GetDestinosUseCase>();
    _destinosFuture = useCase();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AppBarCustom(title: 'Gran República Mochilera'),
      body: FutureBuilder<List<DestinoEntity>>(
        future: _destinosFuture,
        builder: (context, snapshot) {
          final destinos = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: () async {
              final useCase = context.read<GetDestinosUseCase>();
              setState(() {
                _destinosFuture = useCase();
              });
              await _destinosFuture;
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _buildHeader(colors),
                const SizedBox(height: 12),
                _buildQuickActions(context, colors),
                const SizedBox(height: 16),
                _buildCarousel(destinos, colors),
                const SizedBox(height: 12),
                _buildDestinosSection(destinos),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primaryContainer.withOpacity(0.95),
            colors.tertiaryContainer.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido a',
            style: TextStyle(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Gran República Mochilera',
            style: TextStyle(
              color: colors.onPrimaryContainer,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.eco_outlined, color: colors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Explora rutas naturales, cultura y aventuras en un solo lugar.',
                  style: TextStyle(
                    color: colors.onPrimaryContainer.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colors) {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            label: 'Ver destinos',
            icon: Icons.landscape_outlined,
            backgroundColor: colors.primary,
            onPressed: () => context.go('/destinos'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CommonButton(
            label: 'Ver mapa',
            icon: Icons.map_outlined,
            backgroundColor: colors.tertiary,
            onPressed: () => context.go('/mapa'),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(List<DestinoEntity> destinos, ColorScheme colors) {
    if (destinos.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: snapshotMessage(colors),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Destinos destacados',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        CarouselSlider.builder(
          itemCount: destinos.length,
          itemBuilder: (_, index, __) {
            final destino = destinos[index];
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    destino.imagen,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: colors.surfaceVariant,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  bottom: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destino.nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destino.region,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            height: 220,
            enlargeCenterPage: true,
            viewportFraction: 0.86,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinosSection(List<DestinoEntity> destinos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Listo para viajar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => context.go('/destinos'),
              child: const Text('Ver todos'),
            ),
          ],
        ),
        ...destinos.map(
          (destino) => CardItem(
            title: destino.nombre,
            subtitle: destino.region,
            imageUrl: destino.imagen,
            onTap: () => _showDestinoDetalle(destino),
          ),
        ),
      ],
    );
  }

  Widget snapshotMessage(ColorScheme colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.travel_explore_outlined, color: colors.onSurfaceVariant),
        const SizedBox(height: 8),
        Text(
          'Cargando destinos...',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  void _showDestinoDetalle(DestinoEntity destino) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(destino.nombre),
        content: Text(destino.descripcion),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
