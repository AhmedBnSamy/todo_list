import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'themdata_state.dart';
// Define the theme states
enum AppTheme { light, dark }

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('isDark') ?? false;
      emit(isDark ? AppTheme.dark : AppTheme.light);
    } catch (e) {
      print('Error loading theme: $e');
      emit(AppTheme.light); // Fallback to light theme
    }
  }

  Future<void> toggleTheme() async {
    try {
      final newTheme = state == AppTheme.light ? AppTheme.dark : AppTheme.light;
      emit(newTheme);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDark', newTheme == AppTheme.dark);
    } catch (e) {
      print('Error toggling theme: $e');
    }
  }
}