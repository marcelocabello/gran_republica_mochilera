import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/destino_entity.dart';
import '../../../domain/usecases/get_destinos_usecase.dart';
import '../../providers/libreta_provider.dart';
import '../../widgets/app_bar_custom.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  late Future<List<DestinoEntity>> _future;
  final MapController _mapController = MapController();
  DestinoEntity? _destinoSeleccionado;

  @override
  void initState() {
    super.initState();
    _future = context.read<GetDestinosUseCase>()();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const AppBarCustom(title: 'Mapa Sierra Gorda'),
      body: FutureBuilder<List<DestinoEntity>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final destinos = snapshot.data ?? <DestinoEntity>[];
          _destinoSeleccionado ??= destinos.isNotEmpty ? destinos.first : null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildIntro(colors),
              const SizedBox(height: 16),
              _buildMapCard(destinos, colors),
              const SizedBox(height: 16),
              if (_destinoSeleccionado != null)
                _buildSelectedDetail(_destinoSeleccionado!, colors),
              const SizedBox(height: 16),
              _buildPlacesList(destinos, colors),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIntro(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              colors.primaryContainer,
              colors.tertiaryContainer.withValues(alpha: 0.92),
            ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mapa real con OpenStreetMap',
            style: TextStyle(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Reemplacé el mock anterior por un mapa gratuito con teselas reales de OpenStreetMap. Los puntos siguen limitados a la Sierra Gorda para que la ruta sea útil desde Jalpan hasta Arroyo Seco.',
            style: TextStyle(
              color: colors.onPrimaryContainer.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard(List<DestinoEntity> destinos, ColorScheme colors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.public_outlined, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ruta interactiva gratuita',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 1.02,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(21.24, -99.48),
                        initialZoom: 9.1,
                        minZoom: 7.2,
                        maxZoom: 16,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.gran_republica_mochilera',
                          maxNativeZoom: 19,
                        ),
                        MarkerLayer(
                          markers: destinos
                              .map((destino) => _buildMarker(destino, colors))
                              .toList(),
                        ),
                        const RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution('OpenStreetMap contributors'),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: _MapLegendChip(
                        label: 'Sierra Gorda',
                        color: colors.primary,
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: _MapLegendChip(
                        label: 'Gratis',
                        color: colors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pellizca para acercar, muévete libremente por la sierra y toca un pin para ver el cupón desbloqueable del lugar.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Marker _buildMarker(DestinoEntity destino, ColorScheme colors) {
    final seleccionado = _destinoSeleccionado?.nombre == destino.nombre;
    return Marker(
      point: LatLng(destino.latitud, destino.longitud),
      width: 148,
      height: 90,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () {
          setState(() => _destinoSeleccionado = destino);
          _mapController.move(
            LatLng(destino.latitud, destino.longitud),
            11.3,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: seleccionado ? colors.secondary : colors.primary,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                destino.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Icon(
              Icons.location_on,
              size: seleccionado ? 34 : 30,
              color: seleccionado ? colors.secondary : colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDetail(DestinoEntity destino, ColorScheme colors) {
    final libreta = context.watch<LibretaProvider>();
    final tieneSello = libreta.tieneSello(destino.nombre);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      destino.imagen,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: colors.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.56),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Foto real del destino',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              destino.nombre,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(icon: Icons.map_outlined, text: destino.municipio),
                _InfoChip(icon: Icons.terrain_outlined, text: destino.categoria),
                _InfoChip(icon: Icons.route_outlined, text: destino.region),
              ],
            ),
            const SizedBox(height: 12),
            Text(destino.descripcion),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'Cupón disponible: ${destino.recompensaSello}',
                style: TextStyle(
                  color: colors.onSecondaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => libreta.alternarSello(destino.nombre),
              icon: Icon(tieneSello ? Icons.verified : Icons.local_activity_outlined),
              label: Text(tieneSello ? 'Sello registrado' : 'Registrar sello'),
              style: FilledButton.styleFrom(
                backgroundColor: tieneSello ? colors.secondary : colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesList(List<DestinoEntity> destinos, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paradas y cupones',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 10),
        ...destinos.map(
          (destino) {
            final seleccionado = _destinoSeleccionado?.nombre == destino.nombre;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: seleccionado
                      ? colors.secondaryContainer
                      : colors.primaryContainer,
                  child: Icon(
                    seleccionado ? Icons.place : Icons.landscape_outlined,
                    color: seleccionado ? colors.secondary : colors.primary,
                  ),
                ),
                title: Text(destino.nombre),
                subtitle: Text(
                  '${destino.municipio} • ${destino.recompensaSello}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  setState(() => _destinoSeleccionado = destino);
                  _mapController.move(
                    LatLng(destino.latitud, destino.longitud),
                    11.3,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.primary),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}

class _MapLegendChip extends StatelessWidget {
  const _MapLegendChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
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
