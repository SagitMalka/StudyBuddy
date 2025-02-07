import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_buddy/Model/services/course_service.dart';

class CourseListViewModel {
  final CourseService _courseService;
  final StreamController<List<Map<String, dynamic>>> _coursesController = StreamController.broadcast();

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> _allCourses = [];

  CourseListViewModel(this._courseService) {
    _loadCourses();
    searchController.addListener(_filterCourses);
  }

  Stream<List<Map<String, dynamic>>> get coursesStream => _coursesController.stream;

  Future<void> _loadCourses() async {
    _allCourses = await _courseService.fetchAllCourses();
    _coursesController.add(_allCourses); // Emit data to the stream
  }

  void _filterCourses() {
    final query = searchController.text.toLowerCase();
    final filteredCourses = _allCourses.where((course) {
      return (course["name"]?.toLowerCase().contains(query) ?? false) || (course["major"]?.toLowerCase().contains(query) ?? false) || (course["instructor"]?.toLowerCase().contains(query) ?? false) || query.isEmpty;
    }).toList();
    _coursesController.add(filteredCourses);
  }

  void dispose() {
    _coursesController.close();
    searchController.dispose();
  }
}
