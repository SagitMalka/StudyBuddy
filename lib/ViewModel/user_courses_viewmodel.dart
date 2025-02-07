import 'package:study_buddy/Model/services/user_service.dart';

class MyCoursesViewModel {
  final UserService _userService;
  List<Map<String, dynamic>> _myCourses = [];
  List<Map<String, dynamic>> _filteredCourses = [];

  MyCoursesViewModel(this._userService);

  List<Map<String, dynamic>> get filteredCourses => _filteredCourses;

  Future<void> loadUserCourses() async {
    _myCourses = await _userService.fetchUserCourses();
    _filteredCourses = List.from(_myCourses); // Initialize filtered list
  }

  void filterCourses(String query) {
    query = query.toLowerCase();
    _filteredCourses =
        _myCourses.where((course) => (course["name"]?.toLowerCase().contains(query) ?? false) || (course["major"]?.toLowerCase().contains(query) ?? false) || (course["instructor"]?.toLowerCase().contains(query) ?? false) || query.isEmpty).toList();
  }
}
