import 'package:aws_rds_mysql_connection/models/member.dart';
import 'package:aws_rds_mysql_connection/services/mysql_service.dart';
import 'package:flutter/material.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  final _members = <Member>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final members = await MySQLService.getMembers();
      setState(() {
        _members.clear();
        _members.addAll(members);
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _deleteMember(int memberId) async {
    setState(() {
      _isLoading = true; // 로딩 표시 시작
    });

    try {
      await MySQLService.deleteMember(memberId);
      await _loadMembers(); // 데이터 새로고침
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // 로딩 표시 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member List'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 표시
          : ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return ListTile(
            title: Text(member.name),
            subtitle: Text(member.id.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteMember(member.id),
            ),
          );
        },
      ),
    );
  }
}