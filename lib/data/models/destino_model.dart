import '../../domain/entities/destino_entity.dart';

class DestinoModel extends DestinoEntity {
  const DestinoModel({
    required super.nombre,
    required super.region,
    required super.municipio,
    required super.categoria,
    required super.imagen,
    required super.descripcion,
    required super.latitud,
    required super.longitud,
    required super.recompensaSello,
  });

  factory DestinoModel.fromEntity(DestinoEntity entity) {
    return DestinoModel(
      nombre: entity.nombre,
      region: entity.region,
      municipio: entity.municipio,
      categoria: entity.categoria,
      imagen: entity.imagen,
      descripcion: entity.descripcion,
      latitud: entity.latitud,
      longitud: entity.longitud,
      recompensaSello: entity.recompensaSello,
    );
  }

  DestinoEntity toEntity() => DestinoEntity(
        nombre: nombre,
        region: region,
        municipio: municipio,
        categoria: categoria,
        imagen: imagen,
        descripcion: descripcion,
        latitud: latitud,
        longitud: longitud,
        recompensaSello: recompensaSello,
      );
}
