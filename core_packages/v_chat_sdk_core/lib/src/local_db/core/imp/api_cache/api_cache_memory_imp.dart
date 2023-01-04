import '../../../../models/api_cache_model.dart';
import '../../abstraction/base_local_api_cache_repo.dart';

class ApiCacheMemoryImp extends BaseLocalApiCacheRepo {
  final _apiCaches = <Map<String, Object?>>[];

  @override
  Future<ApiCacheModel?> getOneByEndPoint(String endpoint) {
    return Future.value();
  }

  @override
  Future<int> insert(ApiCacheModel model) {
    return Future.value(1);
  }

  @override
  Future<void> reCreate() {
    return Future.value();
  }
}
