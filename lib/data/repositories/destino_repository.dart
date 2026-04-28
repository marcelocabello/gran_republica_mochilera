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
        nombre: 'Mision de Jalpan',
        region: 'Sierra Gorda Queretana',
        municipio: 'Jalpan de Serra',
        categoria: 'Patrimonio',
        imagen:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Misi%C3%B3n_Jalpan%2C_Sierra_Gorda.jpg/1200px-Misi%C3%B3n_Jalpan%2C_Sierra_Gorda.jpg',
        descripcion:
            'La mision franciscana mas emblemática de la Sierra Gorda, punto ideal para comenzar la ruta cultural.',
        latitud: 21.2185,
        longitud: -99.4726,
        recompensaSello: 'Cafe de olla + postal conmemorativa',
      ),
      DestinoEntity(
        nombre: 'Rio Escanela y Puente de Dios',
        region: 'Sierra Gorda Queretana',
        municipio: 'Pinal de Amoles',
        categoria: 'Naturaleza',
        imagen:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/R%C3%ADo_Escanela%2C_Puente_De_Dios.jpg/1200px-R%C3%ADo_Escanela%2C_Puente_De_Dios.jpg',
        descripcion:
            'Sendero de agua turquesa, pozas y un puente natural entre paredones de roca.',
        latitud: 21.1322,
        longitud: -99.6257,
        recompensaSello: 'Descuento en tour de senderismo',
      ),
      DestinoEntity(
        nombre: 'Mirador Cuatro Palos',
        region: 'Sierra Gorda Queretana',
        municipio: 'Pinal de Amoles',
        categoria: 'Mirador',
        imagen:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Mirador_Cuatro_Palos%2C_Pinal_de_Amoles%2C_Quer%C3%A9taro%2C_M%C3%A9xico.jpg/1200px-Mirador_Cuatro_Palos%2C_Pinal_de_Amoles%2C_Quer%C3%A9taro%2C_M%C3%A9xico.jpg',
        descripcion:
            'Mirador de alta montaña con niebla baja, amaneceres dramáticos y panorámica de la sierra.',
        latitud: 21.1904,
        longitud: -99.6811,
        recompensaSello: 'Sticker de ruta de altura',
      ),
      DestinoEntity(
        nombre: 'Cascada El Chuveje',
        region: 'Sierra Gorda Queretana',
        municipio: 'Pinal de Amoles',
        categoria: 'Cascadas',
        imagen:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Cascada_El_Chuveje_-_Pinal_de_Amoles%2C_Quer%C3%A9taro.jpg/1200px-Cascada_El_Chuveje_-_Pinal_de_Amoles%2C_Quer%C3%A9taro.jpg',
        descripcion:
            'Caida de agua rodeada por bosque y cañadas, muy visitada para picnic y foto de aventura.',
        latitud: 21.1358,
        longitud: -99.6172,
        recompensaSello: 'Cupon para bebida artesanal',
      ),
      DestinoEntity(
        nombre: 'Sotano del Barro',
        region: 'Sierra Gorda Queretana',
        municipio: 'Arroyo Seco',
        categoria: 'Aventura',
        imagen:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/S%C3%B3tano_del_Barro.jpg/1200px-S%C3%B3tano_del_Barro.jpg',
        descripcion:
            'Uno de los abismos mas impresionantes de Mexico, famoso por aves y expediciones de observación.',
        latitud: 21.5142,
        longitud: -99.4211,
        recompensaSello: 'Pase 2x1 en experiencia guiada',
      ),
      DestinoEntity(
        nombre: 'Mision de Landa',
        region: 'Sierra Gorda Queretana',
        municipio: 'Landa de Matamoros',
        categoria: 'Patrimonio',
        imagen:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Misi%C3%B3n_de_Landa_de_Matamoros_11.jpg/1200px-Misi%C3%B3n_de_Landa_de_Matamoros_11.jpg',
        descripcion:
            'Fachada barroca serrana y centro histórico pequeño, ideal para turismo cultural en ruta.',
        latitud: 21.1821,
        longitud: -99.3186,
        recompensaSello: 'Sello dorado de mision franciscana',
      ),
    ];
  }
}
