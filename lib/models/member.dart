class Member {
  final int id;
  final String name;

  Member({required this.id, required this.name});

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: int.tryParse(map['id'].toString()) ?? 0, // 숫자가 아닌 경우 0 반환
      name: map['name'] as String,
    );
  }
}