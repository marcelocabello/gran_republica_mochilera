import '../../domain/entities/destino_entity.dart';

class DestinoModel extends DestinoEntity {
  const DestinoModel({
    required super.nombre,
    required super.region,
    required super.imagen,
    required super.descripcion,
  });

  factory DestinoModel.fromEntity(DestinoEntity entity) {
    return DestinoModel(
      nombre: entity.nombre,
      region: entity.region,
      imagen: entity.imagen,
      descripcion: entity.descripcion,
    );
  }

  DestinoEntity toEntity() => DestinoEntity(
        nombre: nombre,
        region: region,
        imagen: imagen,
        descripcion: descripcion,
      );
}
