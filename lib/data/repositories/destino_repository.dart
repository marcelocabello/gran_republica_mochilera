import '../../domain/entities/destino_entity.dart';

abstract class IDestinoRepository {
  Future<List<DestinoEntity>> getDestinos();
}

class DestinoRepositoryMock implements IDestinoRepository {
  @override
  Future<List<DestinoEntity>> getDestinos() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const [
      DestinoEntity(
        nombre: 'Lago Escondido',
        region: 'Patagonia',
        imagen:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1200&q=80',
        descripcion: 'Bosques eternos y aguas cristalinas para explorar.',
      ),
      DestinoEntity(
        nombre: 'Isla Verde',
        region: 'Caribe',
        imagen:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
        descripcion: 'Playas tranquilas y arenas doradas para desconectar.',
      ),
      DestinoEntity(
        nombre: 'Picos del Sur',
        region: 'Cordillera Andina',
        imagen:
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
        descripcion: 'Senderos de altura y vistas infinitas de montaña.',
      ),
      DestinoEntity(
        nombre: 'Ruta de los Cafetales',
        region: 'Eje Cafetero',
        imagen:
            'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=1200&q=80',
        descripcion: 'Aromas, paisajes y cultura cafetera en cada rincón.',
      ),
      DestinoEntity(
        nombre: 'Ciudad Patrimonio',
        region: 'Centro Histórico',
        imagen:
            'https://images.unsplash.com/photo-1505764706515-aa95265c5abc?auto=format&fit=crop&w=1200&q=80',
        descripcion: 'Calles coloniales y museos vivos llenos de historia.',
      ),
    ];
  }
}
