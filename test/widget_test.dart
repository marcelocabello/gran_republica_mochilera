import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gran_republica_mochilera/app/my_app.dart';
import 'package:gran_republica_mochilera/app/theme.dart';
import 'package:gran_republica_mochilera/data/repositories/destino_repository.dart';
import 'package:gran_republica_mochilera/domain/entities/destino_entity.dart';
import 'package:gran_republica_mochilera/domain/usecases/get_destinos_usecase.dart';
import 'package:gran_republica_mochilera/presentation/providers/libreta_provider.dart';

class _TestDestinoRepository implements IDestinoRepository {
  @override
  Future<List<DestinoEntity>> getDestinos() async => const [
    DestinoEntity(
      nombre: 'Mision de Jalpan',
      region: 'Sierra Gorda Queretana',
      municipio: 'Jalpan de Serra',
      categoria: 'Patrimonio',
      imagen: 'https://example.com/test.jpg',
      descripcion: 'Destino de prueba.',
      latitud: 21.2,
      longitud: -99.4,
      recompensaSello: 'Postal',
    ),
  ];
}

void main() {
  testWidgets('renderiza la app principal', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LibretaProvider()),
          Provider<IDestinoRepository>(create: (_) => _TestDestinoRepository()),
          ProxyProvider<IDestinoRepository, GetDestinosUseCase>(
            update: (_, repository, __) => GetDestinosUseCase(repository),
          ),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Gran República Mochilera'), findsWidgets);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
