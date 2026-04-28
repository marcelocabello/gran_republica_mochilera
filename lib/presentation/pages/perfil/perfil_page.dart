import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../domain/entities/destino_entity.dart';
import '../../../domain/usecases/get_destinos_usecase.dart';
import '../../providers/libreta_provider.dart';
import '../../widgets/app_bar_custom.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late Future<List<DestinoEntity>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<GetDestinosUseCase>()();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final libreta = context.watch<LibretaProvider>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AppBarCustom(title: 'Libreta de cupones'),
      body: FutureBuilder<List<DestinoEntity>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final destinos = snapshot.data ?? <DestinoEntity>[];
          final progreso = libreta.progreso(destinos.length);
          final cupones = _buildCouponOffers(destinos);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(context, progreso, libreta.totalSellos, destinos.length),
              const SizedBox(height: 16),
              _buildNotebook(destinos, libreta, colors),
              const SizedBox(height: 16),
              _buildCouponCatalog(cupones, colors),
              const SizedBox(height: 16),
              _buildStoreSection(colors),
              const SizedBox(height: 16),
              Card(
                child: SwitchListTile(
                  title: const Text('Tema oscuro'),
                  subtitle: const Text('Activa un modo mas relajado para la noche'),
                  value: themeProvider.isDark,
                  onChanged: themeProvider.toggleTheme,
                  secondary: Icon(
                    themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    double progreso,
    int sellos,
    int totalDestinos,
  ) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primaryContainer,
            const Color(0xFFF6E4C8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            height: 78,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progreso,
                  strokeWidth: 8,
                  backgroundColor: colors.primary.withValues(alpha: 0.16),
                  color: colors.secondary,
                ),
                Center(
                  child: Text(
                    '${(progreso * 100).round()}%',
                    style: TextStyle(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Libreta Sierra Gorda',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$sellos de $totalDestinos sellos registrados. Cada visita se convierte en un cupón usable para comida, descuentos y productos locales.',
                  style: TextStyle(
                    color: colors.onPrimaryContainer.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotebook(
    List<DestinoEntity> destinos,
    LibretaProvider libreta,
    ColorScheme colors,
  ) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F1E4),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _NotebookSpine(color: Color(0xFFD7C1A3)),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFBF6ED),
                      Color(0xFFF5EBDD),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(painter: _NotebookLinesPainter()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Libreta con sellos',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF533A23),
                                      ),
                                ),
                              ),
                              Transform.rotate(
                                angle: -0.18,
                                child: _StampedBadge(
                                  label: libreta.totalSellos >= 4
                                      ? 'PREMIO ACTIVO'
                                      : 'RUTA ACTIVA',
                                  color: libreta.totalSellos >= 4
                                      ? colors.secondary
                                      : colors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Ahora sí se presenta como libreta física: papel, espiral y sello visible en cada parada.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF7A634F),
                                ),
                          ),
                          const SizedBox(height: 18),
                          ...destinos.map(
                            (destino) => _NotebookCouponTile(
                              destino: destino,
                              sellado: libreta.tieneSello(destino.nombre),
                              onToggle: () => libreta.alternarSello(destino.nombre),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colors.secondaryContainer.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: colors.secondary.withValues(alpha: 0.28),
                              ),
                            ),
                            child: Text(
                              libreta.totalSellos >= 4
                                  ? 'Recompensa desbloqueada: ya puedes presumir la ruta premium de Sierra Gorda con sello completo.'
                                  : 'Meta recomendada: junta 4 sellos para activar la recompensa fuerte de la ruta.',
                              style: TextStyle(
                                color: colors.onSecondaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCatalog(List<_CouponOffer> cupones, ColorScheme colors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productos, descuentos y comidas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Este apartado aterriza los cupones en beneficios concretos para el viajero.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 14),
            ...cupones.map(
              (cupon) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cupon.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(cupon.icon, color: cupon.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Text(
                                cupon.titulo,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: cupon.color.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  cupon.tipo,
                                  style: TextStyle(
                                    color: cupon.color,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(cupon.descripcion),
                          const SizedBox(height: 6),
                          Text(
                            'Se activa en: ${cupon.destino}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreSection(ColorScheme colors) {
    final productos = const [
      _StoreItem(
        nombre: 'Gorditas serranas',
        detalle: 'Cupón aplica para combo regional o descuento directo.',
        tipo: 'Comida regional',
        icon: Icons.lunch_dining_outlined,
        color: Color(0xFFBF6F2D),
      ),
      _StoreItem(
        nombre: 'Refrescos y aguas frescas',
        detalle: 'Canje rápido para bebida fría después de ruta o caminata.',
        tipo: 'Bebidas',
        icon: Icons.local_drink_outlined,
        color: Color(0xFF2F87A8),
      ),
      _StoreItem(
        nombre: 'Café de olla y pan',
        detalle: 'Perfecto para cupones culturales en misiones y plazas.',
        tipo: 'Cafetería',
        icon: Icons.local_cafe_outlined,
        color: Color(0xFF8C5A36),
      ),
      _StoreItem(
        nombre: 'Postales, stickers y artesanías',
        detalle: 'Descuento para recuerdos físicos de la ruta.',
        tipo: 'Productos',
        icon: Icons.shopping_bag_outlined,
        color: Color(0xFF7760C7),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tienda de cupones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Aquí aterrizamos la parte de tienda: los cupones no solo sellan visitas, también sirven para canjear productos, comida regional y refrescos.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 14),
            ...productos.map(
              (producto) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: producto.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: producto.color.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: producto.color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(producto.icon, color: producto.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producto.nombre,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(producto.detalle),
                          const SizedBox(height: 6),
                          Text(
                            producto.tipo,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: producto.color,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_CouponOffer> _buildCouponOffers(List<DestinoEntity> destinos) {
    final destinoPorNombre = {
      for (final destino in destinos) destino.nombre: destino,
    };

    return [
      _CouponOffer(
        titulo: 'Cafe de olla con pan serrano',
        tipo: 'Comida',
        descripcion:
            'Consumo de bienvenida para quien complete la parada cultural de la misión.',
        destino: destinoPorNombre['Mision de Jalpan']?.nombre ?? 'Mision de Jalpan',
        icon: Icons.local_cafe_outlined,
        color: const Color(0xFF9B5B34),
      ),
      _CouponOffer(
        titulo: '15% en tour de senderismo',
        tipo: 'Descuento',
        descripcion:
            'Descuento pensado para experiencias guiadas alrededor del río y el puente natural.',
        destino: destinoPorNombre['Rio Escanela y Puente de Dios']?.nombre ??
            'Rio Escanela y Puente de Dios',
        icon: Icons.percent_outlined,
        color: const Color(0xFF2F7D6D),
      ),
      _CouponOffer(
        titulo: 'Sticker de ruta panoramica',
        tipo: 'Producto',
        descripcion:
            'Souvenir coleccionable para libreta o botella, inspirado en los amaneceres de altura.',
        destino: destinoPorNombre['Mirador Cuatro Palos']?.nombre ??
            'Mirador Cuatro Palos',
        icon: Icons.sell_outlined,
        color: const Color(0xFF4A6CC3),
      ),
      _CouponOffer(
        titulo: 'Bebida artesanal de la casa',
        tipo: 'Comida',
        descripcion:
            'Canje ideal después de la caminata a la cascada, pensado como recompensa fresca.',
        destino: destinoPorNombre['Cascada El Chuveje']?.nombre ??
            'Cascada El Chuveje',
        icon: Icons.emoji_food_beverage_outlined,
        color: const Color(0xFFDA7C31),
      ),
      _CouponOffer(
        titulo: '2x1 en experiencia guiada',
        tipo: 'Descuento',
        descripcion:
            'Beneficio para observación, aventura o interpretación de naturaleza en la zona alta.',
        destino: destinoPorNombre['Sotano del Barro']?.nombre ?? 'Sotano del Barro',
        icon: Icons.hiking_outlined,
        color: const Color(0xFF7A3F9A),
      ),
      _CouponOffer(
        titulo: 'Sello dorado con postal',
        tipo: 'Producto',
        descripcion:
            'Recuerdo físico premium para la libreta y la ruta de misiones franciscanas.',
        destino: destinoPorNombre['Mision de Landa']?.nombre ?? 'Mision de Landa',
        icon: Icons.auto_awesome_outlined,
        color: const Color(0xFFB78B2E),
      ),
    ];
  }
}

class _NotebookCouponTile extends StatelessWidget {
  const _NotebookCouponTile({
    required this.destino,
    required this.sellado,
    required this.onToggle,
  });

  final DestinoEntity destino;
  final bool sellado;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: sellado
              ? colors.secondary.withValues(alpha: 0.45)
              : const Color(0xFFE2D6C2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destino.nombre,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF4E3825),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${destino.municipio} • ${destino.categoria}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6F5A45),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  destino.recompensaSello,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF8A725C),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: onToggle,
                  icon: Icon(sellado ? Icons.undo : Icons.local_activity_outlined),
                  label: Text(sellado ? 'Quitar sello' : 'Sellar visita'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Transform.rotate(
            angle: sellado ? -0.22 : 0.16,
            child: _StampedBadge(
              label: sellado ? 'SELLADO' : 'PENDIENTE',
              color: sellado ? colors.secondary : const Color(0xFF9E8D79),
            ),
          ),
        ],
      ),
    );
  }
}

class _StampedBadge extends StatelessWidget {
  const _StampedBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 3),
      ),
      child: Center(
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.65),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotebookSpine extends StatelessWidget {
  const _NotebookSpine({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomLeft: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          8,
          (_) => Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1E8),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC0AA8A)),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotebookLinesPainter extends CustomPainter {
  const _NotebookLinesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFD9CDBD)
      ..strokeWidth = 1.1;
    final marginPaint = Paint()
      ..color = const Color(0xFFE4A7A7)
      ..strokeWidth = 1.3;

    for (double y = 70; y < size.height; y += 42) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    canvas.drawLine(
      const Offset(28, 0),
      Offset(28, size.height),
      marginPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CouponOffer {
  const _CouponOffer({
    required this.titulo,
    required this.tipo,
    required this.descripcion,
    required this.destino,
    required this.icon,
    required this.color,
  });

  final String titulo;
  final String tipo;
  final String descripcion;
  final String destino;
  final IconData icon;
  final Color color;
}

class _StoreItem {
  const _StoreItem({
    required this.nombre,
    required this.detalle,
    required this.tipo,
    required this.icon,
    required this.color,
  });

  final String nombre;
  final String detalle;
  final String tipo;
  final IconData icon;
  final Color color;
}
