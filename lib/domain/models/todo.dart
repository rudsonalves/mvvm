import 'dart:convert';

class Todo {
  final String? id;
  final String name;
  final String description;
  final bool done;

  Todo({
    this.id,
    required this.name,
    required this.description,
    this.done = false,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    id != null ? map.addAll({'id': id}) : null;
    map.addAll({'name': name});
    map.addAll({'description': description});
    map.addAll({'done': done});

    return map;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String,
      done: (map['done'] as bool?) ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  Todo copyWith({String? id, String? name, String? description, bool? done}) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      done: done ?? this.done,
    );
  }
}
