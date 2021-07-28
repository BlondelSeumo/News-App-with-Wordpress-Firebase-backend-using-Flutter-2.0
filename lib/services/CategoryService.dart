import 'package:mighty_news_firebase/models/CategoryData.dart';

import '../main.dart';
import 'BaseService.dart';

class CategoryService extends BaseService {
  CategoryService() {
    ref = db.collection('categories');
  }

  Stream<List<CategoryData>> categories() {
    return ref!.snapshots().map((x) => x.docs.map((y) => CategoryData.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Stream<int> totalCategoriesCount() {
    return ref!.snapshots().map((x) => x.docs.length);
  }

  Future<List<CategoryData>> categoriesFuture() async {
    return await ref!.get().then((x) => x.docs.map((y) => CategoryData.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
}
