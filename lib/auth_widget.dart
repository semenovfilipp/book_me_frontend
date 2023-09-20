import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late PostgreSQLConnection connection;

  @override
  void initState() {
    super.initState();
    _initializeDatabaseConnection();
  }



  Future<void> _initializeDatabaseConnection() async {
    // Инициализируем соединение с базой данных
    connection = PostgreSQLConnection(
      "localhost",
      5432,
      "book_base",
      username: "postgres",
      password: "admin",
    );
    try {
      await connection.open();
      print("Соединение успешно");
    } catch (e) {
      print("Ошибка соединения $e");
    }
  }

  Future<void> login() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    // Пример выполнения SQL-запроса
    final results = await connection.query(
        'SELECT * FROM users WHERE username = @username AND password = @password',
        substitutionValues: {'username': username, 'password': password});

    if (results.isNotEmpty) {
      // Пользователь существует и вошел в систему
      print('Пользователь вошел в систему');
    } else {
      // Пользователь не существует или введены неверные учетные данные
      print('Ошибка входа');
    }
  }

  Future<void> register() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    // Здесь вы можете выполнить операцию регистрации пользователя в базе данных
    // Например, выполнить запрос INSERT для добавления нового пользователя

    // Пример выполнения SQL-запроса для регистрации
    try {
      await connection.query(
          'INSERT INTO users (username, password) VALUES (@username, @password)',
          substitutionValues: {'username': username, 'password': password});
      print("Успешная регистрация");
    } catch (e) {
      print("Ошибка регистрации $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход/Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Имя пользователя'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: login,
                  child: Text('Войти'),
                ),
                ElevatedButton(
                  onPressed: register,
                  child: Text('Зарегистрироваться'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection.close();
  }
}
