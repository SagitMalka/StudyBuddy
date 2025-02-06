class Course {
  final String name;
  final String major;

  Course({required this.name, required this.major});

  factory Course.fromMap(Map<String, dynamic> data) {
    return Course(
      name: data['name'],
      major: data['major'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'major': major,
    };
  }
}
