import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/destino_entity.dart';
import '../../../domain/usecases/get_destinos_usecase.dart';
import '../../providers/libreta_provider.dart';
import '../../widgets/app_bar_custom.dart';
import '../../widgets/card_item.dart';

class DestinosPage extends StatefulWidget {
  const DestinosPage({super.key});

  @override
  State<DestinosPage> createState() => _DestinosPageState();
}

class _DestinosPageState extends State<DestinosPage> {
  late Future<List<DestinoEntity>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<GetDestinosUseCase>()();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'Destinos'),
      body: FutureBuilder<List<DestinoEntity>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final destinos = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: destinos.length,
            itemBuilder: (_, index) {
              final destino = destinos[index];
              return CardItem(
                title: destino.nombre,
                subtitle: '${destino.municipio} • ${destino.region}',
                badge: destino.categoria,
                imageUrl: destino.imagen,
                onTap: () => _showDetalle(destino),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetalle(DestinoEntity destino) {
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
              'Coordenadas: ${destino.latitud.toStringAsFixed(4)}, ${destino.longitud.toStringAsFixed(4)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Cupon: ${destino.recompensaSello}',
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
            icon: const Icon(Icons.check_circle_outline),
            label: Text(
              libreta.tieneSello(destino.nombre) ? 'Quitar sello' : 'Agregar sello',
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
