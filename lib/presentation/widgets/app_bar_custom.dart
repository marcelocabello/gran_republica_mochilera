import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarCustom({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 6);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return AppBar(
      titleSpacing: 16,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
      centerTitle: false,
      actions: actions,
      elevation: 0,
      backgroundColor: colors.primary.withOpacity(0.9),
      surfaceTintColor: colors.primary,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.primary.withOpacity(0.92),
              colors.primaryContainer.withOpacity(0.80),
            ],
          ),
        ),
      ),
    );
  }
}
