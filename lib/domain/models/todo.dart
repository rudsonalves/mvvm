import 'dart:convert';

class Todo {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool done;

  Todo({
    required this.id,
    required this.name,
    required this.description,
    DateTime? createdAt,
    this.completedAt,
    this.done = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map.addAll({'id': id});
    map.addAll({'name': name});
    map.addAll({'description': description});
    map.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    map.addAll({'completedAt': completedAt?.millisecondsSinceEpoch});
    map.addAll({'done': done});

    return map;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      completedAt:
          map['completedAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'] as int)
              : null,
      done: (map['done'] as bool?) ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  Todo copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? done,
  }) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      done: done ?? this.done,
    );
  }
}
