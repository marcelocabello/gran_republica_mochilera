import 'package:flutter/material.dart';

import '../../widgets/app_bar_custom.dart';

class TiendaPage extends StatelessWidget {
  const TiendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tiendas = _StoreSpot.values;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AppBarCustom(title: 'Tienda Sierra Gorda'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primaryContainer,
                  colors.tertiaryContainer.withValues(alpha: 0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comida, recuerditos y ofertas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colors.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Toca cualquier lugar para abrir sus reseñas, ver menú, revisar promociones y decidir dónde canjear tus cupones.',
                  style: TextStyle(
                    color: colors.onPrimaryContainer.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...tiendas.map((tienda) => _StoreCard(store: tienda)),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store});

  final _StoreSpot store;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showStoreDetail(context, store),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: store.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(store.icon, color: store.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${store.location} • ${store.type}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      store.offer,
                      style: TextStyle(
                        color: colors.onSecondaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(store.description),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip(
                    icon: Icons.star_rounded,
                    text: '${store.rating} / 5',
                    color: const Color(0xFFE4A11B),
                  ),
                  _MetaChip(
                    icon: Icons.reviews_outlined,
                    text: '${store.reviews} reseñas',
                    color: colors.primary,
                  ),
                  _MetaChip(
                    icon: Icons.redeem_outlined,
                    text: store.coupon,
                    color: colors.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Lo recomendado aquí',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: store.highlights
                    .map(
                      (item) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.touch_app_outlined, size: 18, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Toca para ver reseñas, menú y ofertas',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStoreDetail(BuildContext context, _StoreSpot store) {
    final colors = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.82,
            minChildSize: 0.55,
            maxChildSize: 0.94,
            builder: (context, controller) {
              return ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: store.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(store.icon, color: store.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.title,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text('${store.location} • ${store.type}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaChip(
                        icon: Icons.star_rounded,
                        text: '${store.rating} / 5',
                        color: const Color(0xFFE4A11B),
                      ),
                      _MetaChip(
                        icon: Icons.reviews_outlined,
                        text: '${store.reviews} reseñas',
                        color: colors.primary,
                      ),
                      _MetaChip(
                        icon: Icons.local_offer_outlined,
                        text: store.offer,
                        color: colors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SectionTitle(title: 'Ofertas activas'),
                  const SizedBox(height: 8),
                  ...store.offers.map(
                    (offer) => _BulletCard(
                      icon: Icons.sell_outlined,
                      title: offer,
                      color: colors.secondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionTitle(title: 'Menú y productos'),
                  const SizedBox(height: 8),
                  ...store.menu.map(
                    (item) => _BulletCard(
                      icon: Icons.restaurant_menu_outlined,
                      title: item,
                      color: store.color,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionTitle(title: 'Reseñas destacadas'),
                  const SizedBox(height: 8),
                  ...store.sampleReviews.map(
                    (review) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.format_quote, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  review.author,
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < review.stars
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 16,
                                    color: const Color(0xFFE4A11B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(review.comment),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class _BulletCard extends StatelessWidget {
  const _BulletCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

enum _StoreSpot {
  comedorJalpan(
    'Comedor del Centro Jalpan',
    'Jalpan de Serra',
    'Comida regional',
    '10% en gorditas y café',
    'Cupón de comida regional',
    4.7,
    128,
    'Parada ideal para probar gorditas serranas, cecina y café de olla en el corazón de la ruta.',
    ['Gorditas serranas', 'Café de olla', 'Cecina', 'Aguas frescas'],
    [
      'Gorditas serranas de maíz quebrado',
      'Cecina con enchiladas queretanas',
      'Café de olla con canela',
      'Agua fresca de guayaba',
    ],
    [
      '10% de descuento al presentar cupón de ruta',
      'Combo café + gordita a precio especial',
      'Refill gratis en agua fresca después de las 2 pm',
    ],
    [
      _StoreReview('Mariana V.', 5, 'Las gorditas salen calientitas y el café de olla sí sabe casero. Muy buena parada antes de seguir la ruta.'),
      _StoreReview('Luis R.', 4, 'Buen sazón y atención rápida. La cecina vale mucho la pena si vienes con hambre.'),
    ],
    Icons.restaurant_menu_outlined,
    Color(0xFFBA6B2D),
  ),
  dulcesPinal(
    'Dulces y Recuerdos Pinal',
    'Pinal de Amoles',
    'Recuerditos',
    '2x1 en sticker o postal',
    'Cupón para producto local',
    4.6,
    94,
    'Espacio pensado para llevar artesanías, postales y antojitos empaquetados después del mirador o la cascada.',
    ['Postales', 'Stickers', 'Dulces típicos', 'Bolsas artesanales'],
    [
      'Postales ilustradas de Sierra Gorda',
      'Stickers de miradores y misiones',
      'Dulces de leche y fruta',
      'Bolsas artesanales bordadas',
    ],
    [
      '2x1 en sticker o postal seleccionada',
      '12% en compra de dos recuerditos',
      'Bolsa artesanal con precio especial usando cupón',
    ],
    [
      _StoreReview('Karen V.', 5, 'Muy bonitos los recuerditos, sí se sienten de la región y no solo genéricos.'),
      _StoreReview('Pedro S.', 4, 'Las postales están padrísimas y los dulces sirven mucho para llevar algo ligero.'),
    ],
    Icons.shopping_bag_outlined,
    Color(0xFF5C7BD9),
  ),
  cafeLanda(
    'Café Neblinas de Landa',
    'Landa de Matamoros',
    'Cafetería y tienda',
    'Bebida gratis en compra local',
    'Cupón para bebida',
    4.8,
    76,
    'Buen punto para probar café serrano, pan de pulque y comprar producto regional para llevar.',
    ['Café regional', 'Pan de pulque', 'Mermeladas', 'Licores artesanales'],
    [
      'Café de especialidad de Neblinas',
      'Pan de pulque recién horneado',
      'Mermelada artesanal de temporada',
      'Licor de fruta regional',
    ],
    [
      'Bebida gratis en compra de producto local',
      'Cata corta de café los fines de semana',
      'Descuento en mermeladas con cupón de libreta',
    ],
    [
      _StoreReview('Ana C.', 5, 'El café está muy rico y el pan de pulque combina perfecto. Se siente como parada obligada.'),
      _StoreReview('Jorge T.', 5, 'Muy buen lugar para comprar algo local y descansar un rato antes de seguir el camino.'),
    ],
    Icons.local_cafe_outlined,
    Color(0xFF875637),
  ),
  snacksMision(
    'Parador Misión y Snacks',
    'Jalpan de Serra',
    'Bebidas y snacks',
    '15% en refrescos y botana',
    'Cupón rápido de refresco',
    4.4,
    61,
    'Útil para viajeros que quieren un canje rápido: refrescos, aguas embotelladas y botanas locales.',
    ['Refrescos', 'Botanas', 'Agua fresca', 'Souvenirs pequeños'],
    [
      'Refrescos fríos y aguas embotelladas',
      'Papas y botanas locales',
      'Agua fresca del día',
      'Souvenirs pequeños de misión',
    ],
    [
      '15% en refrescos y botana',
      'Botella de agua con descuento en ruta larga',
      'Combo rápido para carretera',
    ],
    [
      _StoreReview('Mónica G.', 4, 'Muy práctico para agarrar algo rápido antes del siguiente tramo.'),
      _StoreReview('Iván P.', 4, 'Buen precio en bebidas y sí hace paro cuando vienes cansado del mapa o caminata.'),
    ],
    Icons.local_drink_outlined,
    Color(0xFF2E8AA7),
  ),
  mercadoArtesanal(
    'Corredor Artesanal Sierra Gorda',
    'Landa y Jalpan',
    'Artesanías',
    '12% en recuerditos seleccionados',
    'Cupón de artesanía',
    4.9,
    143,
    'Selección de recuerditos con enfoque serrano: textiles, palma, madera, postales y piezas decorativas.',
    ['Artesanías', 'Textiles', 'Palma', 'Madera tallada'],
    [
      'Textiles y bordados regionales',
      'Piezas en palma y mimbre',
      'Madera tallada decorativa',
      'Postales y recuerdos de misión',
    ],
    [
      '12% en recuerditos seleccionados',
      'Promoción en compra de dos artesanías',
      'Postal gratis en compra arriba del mínimo',
    ],
    [
      _StoreReview('Fernanda L.', 5, 'Aquí encontré los mejores recuerditos para llevar y varias cosas sí se ven hechas localmente.'),
      _StoreReview('Raúl M.', 5, 'Muy buena variedad de artesanías; ideal si quieres comprar algo más especial que un souvenir típico.'),
    ],
    Icons.storefront_outlined,
    Color(0xFF7B5AB5),
  );

  const _StoreSpot(
    this.title,
    this.location,
    this.type,
    this.offer,
    this.coupon,
    this.rating,
    this.reviews,
    this.description,
    this.highlights,
    this.menu,
    this.offers,
    this.sampleReviews,
    this.icon,
    this.color,
  );

  final String title;
  final String location;
  final String type;
  final String offer;
  final String coupon;
  final double rating;
  final int reviews;
  final String description;
  final List<String> highlights;
  final List<String> menu;
  final List<String> offers;
  final List<_StoreReview> sampleReviews;
  final IconData icon;
  final Color color;
}

class _StoreReview {
  const _StoreReview(this.author, this.stars, this.comment);

  final String author;
  final int stars;
  final String comment;
}
