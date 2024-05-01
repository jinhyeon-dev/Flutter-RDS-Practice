// import 'package:flutter/material.dart';
// import 'package:mysql_client/mysql_client.dart';
//
// class MemberListScreen extends StatefulWidget {
//   const MemberListScreen({Key? key}) : super(key: key);
//
//   @override
//   _MemberListScreenState createState() => _MemberListScreenState();
// }
//
// class _MemberListScreenState extends State<MemberListScreen> {
//   List<Map<String, dynamic>> _members = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMembers();
//   }
//
//   Future<void> _loadMembers() async {
//     print("Connecting to mysql server...");
//
//     // MySQL 접속 설정
//     final conn = await MySQLConnection.createConnection(
//       host: 'demo.cnyscyowakl3.ap-northeast-2.rds.amazonaws.com',
//       port: 3306,
//       userName: 'admin',
//       password: 'aws-rds-jinhyeon',
//       databaseName: 'demo', // optional
//     );
//
//     await conn.connect();
//
//     print("Connected");
//
//     final result = await conn.execute("SELECT * FROM memberTable");
//
//     if (result != null && result.isNotEmpty) {
//       setState(() {
//         _members = result.rows.map((row) => row.assoc()).toList();
//         _isLoading = false; // 데이터 로딩 완료
//       });
//     }
//
//     await conn.close();
//   }
//
//   Future<void> _deleteMember(String memberId) async {
//     // memberId를 int로 파싱
//     final int parsedMemberId = int.tryParse(memberId) ?? 0;
//
//     // MySQL 접속 설정
//     final conn = await MySQLConnection.createConnection(
//       host: 'demo.cnyscyowakl3.ap-northeast-2.rds.amazonaws.com',
//       port: 3306,
//       userName: 'admin',
//       password: 'aws-rds-jinhyeon',
//       databaseName: 'demo', // optional
//     );
//
//     await conn.connect();
//
//     print("Connected");
//
//     // 회원 삭제 쿼리 실행
//     await conn.execute("DELETE FROM memberTable WHERE id = :id", {"id": parsedMemberId});
//
//     print("Member deleted successfully");
//
//     await conn.close();
//
//     // 삭제 후 화면 갱신
//     setState(() {
//       _members.removeWhere((member) => member['id'] == parsedMemberId);
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Member List'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(), // 로딩 표시
//       )
//           : ListView.builder(
//         itemCount: _members.length,
//         itemBuilder: (context, index) {
//           final member = _members[index];
//           return ListTile(
//             title: Text(member['name']),
//             subtitle: Text(member['id'].toString()),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 _deleteMember(member['id']);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    print("Connecting to mysql server...");
    final conn = await MySQLConnection.createConnection(
      host: 'demo.cnyscyowakl3.ap-northeast-2.rds.amazonaws.com',
      port: 3306,
      userName: 'admin',
      password: 'aws-rds-jinhyeon',
      databaseName: 'demo',
    );

    await conn.connect();
    print("Connected");

    final result = await conn.execute("SELECT * FROM memberTable");

    if (result != null && result.isNotEmpty) {
      setState(() {
        _members = result.rows.map((row) => row.assoc()).toList();
        _isLoading = false;
      });
    }

    await conn.close();
  }

  Future<void> _deleteMember(String memberId) async {
    final int parsedMemberId = int.tryParse(memberId) ?? 0;
    final conn = await MySQLConnection.createConnection(
      host: 'demo.cnyscyowakl3.ap-northeast-2.rds.amazonaws.com',
      port: 3306,
      userName: 'admin',
      password: 'aws-rds-jinhyeon',
      databaseName: 'demo',
    );

    await conn.connect();
    await conn.execute("DELETE FROM memberTable WHERE id = :id", {"id": parsedMemberId});
    print("Member deleted successfully");
    await conn.close();

    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    await _loadMembers();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member List'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return ListTile(
            title: Text(member['name']),
            subtitle: Text(member['id'].toString()),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteMember(member['id'].toString());
              },
            ),
          );
        },
      ),
    );
  }
}
