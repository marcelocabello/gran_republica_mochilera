import 'package:flutter/foundation.dart';

class LibretaProvider extends ChangeNotifier {
  final Set<String> _sellos = <String>{};

  List<String> get sellos => _sellos.toList()..sort();

  int get totalSellos => _sellos.length;

  bool tieneSello(String destino) => _sellos.contains(destino);

  void alternarSello(String destino) {
    if (_sellos.contains(destino)) {
      _sellos.remove(destino);
    } else {
      _sellos.add(destino);
    }
    notifyListeners();
  }

  double progreso(int totalDestinos) {
    if (totalDestinos == 0) return 0;
    return _sellos.length / totalDestinos;
  }
}
