class Task {
  final String name;
  final String description;

  Task(this.name, this.description);

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        json['name'],
        json['description']
    );
  }
}