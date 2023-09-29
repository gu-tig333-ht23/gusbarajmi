class Task {
  final String id;
  final String title;
  final bool done;

  Task({
    required this.id,
    required this.title,
    required this.done,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? done,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '', // Provide a default value or an empty string
      title: json['title'],
      done: json['done'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'done': done,
      };
}
