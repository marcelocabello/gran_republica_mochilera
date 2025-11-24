import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/my_app.dart';
import 'app/theme.dart';
import 'data/repositories/destino_repository.dart';
import 'domain/usecases/get_destinos_usecase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<IDestinoRepository>(create: (_) => DestinoRepositoryMock()),
        ProxyProvider<IDestinoRepository, GetDestinosUseCase>(
          update: (_, repository, __) => GetDestinosUseCase(repository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
