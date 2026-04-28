import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badge;
  final String imageUrl;
  final VoidCallback? onTap;

  const CardItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: DestinationImage(
                imageUrl: imageUrl,
                title: title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: colors.secondaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge!,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: colors.onSecondaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DestinationImage extends StatelessWidget {
  const DestinationImage({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _DestinationFallback(
          title: title,
          subtitle: 'Cargando foto del destino...',
          icon: Icons.photo_camera_back_outlined,
          color: colors.primary,
        );
      },
      errorBuilder: (_, __, ___) => _DestinationFallback(
        title: title,
        subtitle: 'Foto no disponible por red externa',
        icon: Icons.image_not_supported_outlined,
        color: colors.tertiary,
      ),
    );
  }
}

class _DestinationFallback extends StatelessWidget {
  const _DestinationFallback({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteForTitle(title);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            palette.$1,
            palette.$2,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -10,
            child: Icon(
              Icons.landscape_rounded,
              size: 140,
              color: Colors.white.withValues(alpha: 0.16),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 30, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Vista ilustrativa del destino',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _paletteForTitle(String seed) {
    final palettes = <(Color, Color)>[
      (const Color(0xFFB7D8BE), const Color(0xFF99C9F2)),
      (const Color(0xFFD7D0B3), const Color(0xFFA5C8B0)),
      (const Color(0xFFC3D6E8), const Color(0xFF9EC0E1)),
      (const Color(0xFFC9E0C5), const Color(0xFFE2C9A1)),
    ];
    final index = seed.runes.fold<int>(0, (value, rune) => value + rune) %
        palettes.length;
    return palettes[index];
  }
}
