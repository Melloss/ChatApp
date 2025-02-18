// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  final int id;
  final String text;
  final DateTime updatedDate;
  final int toUser;
  final int fromUser;
  final bool isSeen;
  final bool isEdited;
  ChatModel({
    required this.id,
    required this.text,
    required this.updatedDate,
    required this.toUser,
    required this.fromUser,
    required this.isSeen,
    required this.isEdited,
  });

  ChatModel copyWith({
    int? id,
    String? text,
    DateTime? updatedDate,
    int? toUser,
    int? fromUser,
    bool? isSeen,
    bool? isEdited,
  }) {
    return ChatModel(
      id: id ?? this.id,
      text: text ?? this.text,
      updatedDate: updatedDate ?? this.updatedDate,
      toUser: toUser ?? this.toUser,
      fromUser: fromUser ?? this.fromUser,
      isSeen: isSeen ?? this.isSeen,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
      'toUser': toUser,
      'fromUser': fromUser,
      'isSeen': isSeen,
      'isEdited': isEdited,
    };
  }

  factory ChatModel.fromMap(Map map) {
    return ChatModel(
      id: map['id'] as int,
      text: map['text'] as String,
      updatedDate: DateTime.parse(map['updated_date']),
      toUser: map['to_user'] as int,
      fromUser: map['from_user'] as int,
      isSeen: map['is_seen'] as bool,
      isEdited: map['is_edited'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(id: $id, text: $text, updatedDate: $updatedDate, toUser: $toUser, fromUser: $fromUser, isSeen: $isSeen, isEdited: $isEdited)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.updatedDate == updatedDate &&
        other.toUser == toUser &&
        other.fromUser == fromUser &&
        other.isSeen == isSeen &&
        other.isEdited == isEdited;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        updatedDate.hashCode ^
        toUser.hashCode ^
        fromUser.hashCode ^
        isSeen.hashCode ^
        isEdited.hashCode;
  }
}

/*

  "id": 0,
  "text": "string",
  "updated_date": "string",
  "to_user": 0,
  "from_user": 0,
  "is_seen": true,
  "is_edited": true
}
*/