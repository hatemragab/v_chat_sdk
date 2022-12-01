import '../../../models/api_cache_model.dart';

abstract class BaseLocalApiCacheRepo {
  Future<int> insert(ApiCacheModel model);

  Future<ApiCacheModel?> getOneByEndPoint(String endpoint);

  Future<void> reCreate();
}
