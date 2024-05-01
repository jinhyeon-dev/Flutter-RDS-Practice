import 'package:mysql_client/mysql_client.dart';
import 'package:aws_rds_mysql_connection/models/member.dart';

class MySQLService {
  static Future<MySQLConnection> _getConnection() async {
    return await MySQLConnection.createConnection(
      host: 'demo.cnyscyowakl3.ap-northeast-2.rds.amazonaws.com',
      port: 3306,
      userName: 'admin',
      password: 'aws-rds-jinhyeon',
      databaseName: 'demo',
    );
  }

  static Future<List<Member>> getMembers() async {
    final conn = await _getConnection();
    try {
      await conn.connect();
      final result = await conn.execute('SELECT * FROM memberTable');
      return result.rows.map((row) => Member.fromMap(row.assoc())).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  static Future<void> deleteMember(int memberId) async {
    final conn = await _getConnection();
    try {
      await conn.connect();
      await conn.execute('DELETE FROM memberTable WHERE id = :id', {'id': memberId});
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
    }
  }

  static Future<void> addMember(String id, String name) async {
    final conn = await _getConnection();
    try {
      await conn.connect();
      await conn.execute(
        "INSERT INTO memberTable (id, name) VALUES (:id, :name)",
        {"id": id, "name": name},
      );
      print("Member added successfully");
    } catch (e) {
      print('Error: $e');
    } finally {
      await conn.close();
    }
  }
}


