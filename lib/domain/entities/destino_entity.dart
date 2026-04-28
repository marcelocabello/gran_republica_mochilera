class DestinoEntity {
  final String nombre;
  final String region;
  final String municipio;
  final String categoria;
  final String imagen;
  final String descripcion;
  final double latitud;
  final double longitud;
  final String recompensaSello;

  const DestinoEntity({
    required this.nombre,
    required this.region,
    required this.municipio,
    required this.categoria,
    required this.imagen,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.recompensaSello,
  });
}
