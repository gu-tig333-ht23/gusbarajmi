class Task {
  final String id;
  final String title;
  bool isCompleted;
  // Define constructor according to API requirements
  Task({
    this.id = '',
    required this.title,
    required this.isCompleted,
  });
  // Converts from json
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'],
      isCompleted: json['done'] ?? false,
    );
  }
  // Converts to json
  Map<String, dynamic> toJson() => {
        'title': title,
        'done': isCompleted,
      };
}
