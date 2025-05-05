import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static const String _dimensionKey = 'current_dimension';

  static Future<int> loadDimension() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dimensionKey) ?? 0;
  }

  static Future<void> saveDimension(int dimension) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dimensionKey, dimension);
  }
}
