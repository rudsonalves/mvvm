import 'dart:convert';

class Todo {
  final String? id;
  final String name;

  Todo({this.id, required this.name});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    id != null ? result.addAll({'id': id}) : null;
    result.addAll({'name': name});

    return result;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(id: map['id'], name: map['name'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  Todo copyWith({String? id, String? name}) {
    return Todo(id: id ?? this.id, name: name ?? this.name);
  }
}
