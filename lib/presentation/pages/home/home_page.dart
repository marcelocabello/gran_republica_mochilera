import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/destino_entity.dart';
import '../../../domain/usecases/get_destinos_usecase.dart';
import '../../providers/libreta_provider.dart';
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
                _buildStorePreview(colors),
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
            colors.primaryContainer.withValues(alpha: 0.95),
            colors.tertiaryContainer.withValues(alpha: 0.85),
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
                  'Explora la Sierra Gorda queretana entre misiones, cascadas, miradores y rutas serranas.',
                  style: TextStyle(
                    color: colors.onPrimaryContainer.withValues(alpha: 0.9),
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
          color: colors.surfaceContainerHighest,
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
                  child: DestinationImage(
                    imageUrl: destino.imagen,
                    title: destino.nombre,
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
                        const SizedBox(height: 4),
                        Text(
                          destino.municipio,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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

  Widget _buildStorePreview(ColorScheme colors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tienda y canjes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tus cupones también sirven para comida regional, refrescos, recuerdos y descuentos locales.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 14),
            const Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StoreChip(label: 'Gorditas serranas', icon: Icons.lunch_dining_outlined),
                _StoreChip(label: 'Refrescos y bebidas', icon: Icons.local_drink_outlined),
                _StoreChip(label: 'Café de olla', icon: Icons.local_cafe_outlined),
                _StoreChip(label: 'Artesanías y postales', icon: Icons.shopping_bag_outlined),
              ],
            ),
          ],
        ),
      ),
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
            subtitle: '${destino.municipio} • ${destino.region}',
            badge: destino.categoria,
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
    final libreta = context.read<LibretaProvider>();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(destino.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${destino.municipio} • ${destino.categoria}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Text(destino.descripcion),
            const SizedBox(height: 12),
            Text(
              'Cupon desbloqueable: ${destino.recompensaSello}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              libreta.alternarSello(destino.nombre);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    libreta.tieneSello(destino.nombre)
                        ? 'Sello agregado a la libreta'
                        : 'Sello retirado de la libreta',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.local_activity_outlined),
            label: Text(
              libreta.tieneSello(destino.nombre) ? 'Quitar sello' : 'Sellar visita',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _StoreChip extends StatelessWidget {
  const _StoreChip({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.secondaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colors.secondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
