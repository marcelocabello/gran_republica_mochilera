import '../entities/destino_entity.dart';
import '../../data/repositories/destino_repository.dart';

class GetDestinosUseCase {
  final IDestinoRepository repository;

  GetDestinosUseCase(this.repository);

  Future<List<DestinoEntity>> call() {
    return repository.getDestinos();
  }
}
