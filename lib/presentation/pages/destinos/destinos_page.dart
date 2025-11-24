import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/destino_entity.dart';
import '../../../domain/usecases/get_destinos_usecase.dart';
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
                subtitle: destino.region,
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
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(destino.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(destino.region, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(destino.descripcion),
          ],
        ),
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
