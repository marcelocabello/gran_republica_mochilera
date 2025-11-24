import 'package:flutter/material.dart';

import '../../widgets/app_bar_custom.dart';

class CategoriasPage extends StatelessWidget {
  const CategoriasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = _Category.values;

    return Scaffold(
      appBar: const AppBarCustom(title: 'Categorías'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];
          return Card(
            elevation: 1.5,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
                child: Icon(category.icon, color: Theme.of(context).colorScheme.primary),
              ),
              title: Text(category.title),
              subtitle: Text(category.description),
            ),
          );
        },
      ),
    );
  }
}

enum _Category {
  playa('Playa', Icons.beach_access_outlined, 'Arena fina, aguas claras y relax.'),
  montana('Montaña', Icons.terrain_outlined, 'Senderos, picos y aire puro.'),
  cultura('Cultura', Icons.museum_outlined, 'Historia viva y arte en cada esquina.'),
  gastronomia('Gastronomía', Icons.restaurant_menu_outlined, 'Sabores locales y experiencias únicas.'),
  aventura('Aventura', Icons.hiking_outlined, 'Adrenalina, rafting y rutas extremas.');

  const _Category(this.title, this.icon, this.description);

  final String title;
  final IconData icon;
  final String description;
}
