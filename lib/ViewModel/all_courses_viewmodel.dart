import 'package:flutter/material.dart';
import '../view/services/course_service.dart';

class AllCoursesViewmodel extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allCourses = [];
  List<Map<String, dynamic>> _filteredCourses = [];

  List<Map<String, dynamic>> get filteredCourses => _filteredCourses;
  TextEditingController get searchController => _searchController;
  AllCoursesViewmodel() {
    _loadCourses();
    _searchController.addListener(_filterCourses);
  }
  Future<void> _loadCourses() async {
    final courses = await _courseService.fetchAllCourses();
    _allCourses = courses;
    _filteredCourses = courses;
    notifyListeners();
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    _filteredCourses =
        _allCourses.where((course) => (course["name"]?.toLowerCase().contains(query) ?? false) || (course["major"]?.toLowerCase().contains(query) ?? false) || (course["instructor"]?.toLowerCase().contains(query) ?? false) || query.isEmpty).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
