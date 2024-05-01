import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddMemberScreen(),
    );
  }
}

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID',
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addMember(_idController.text, _nameController.text);
                },
                child: const Text('Add Member'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addMember(String id, String name) async {
    print("Connecting to mysql server...");

    // MySQL 접속 설정
    final conn = await MySQLConnection.createConnection(
      host: 'demo.cnyscyowakl3.ap-northeast-2.rds.amazonaws.com',
      port: 3306,
      userName: 'admin',
      password: 'aws-rds-jinhyeon',
      databaseName: 'demo', // optional
    );

    await conn.connect();

    print("Connected");

    await conn.execute(
      "INSERT INTO memberTable (id, name) VALUES (:id, :name)",
      {"id": id, "name": name},
    );

    print("Member added successfully");

    await conn.close();
  }
}
