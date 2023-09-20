
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';

class ConnectionTest {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late PostgreSQLConnection connection;


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

  Future<void> register(String username, String password) async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    try {
      // Выполняем запрос для регистрации пользователя
      await connection.query(
          'INSERT INTO users (username, password) VALUES (@username, @password)',
          substitutionValues: {'username': username, 'password': password});
      print("Пользователь зарегистрирован");
    } catch (e) {
      print("Ошибка при регистрации пользователя: $e");
    }
  }

  Future<void> login(String username, String password) async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    try {
      await connection.query(
          'SELECT * FROM users WHERE username = @username AND password = @password',
          substitutionValues: {'username': username, 'password': password});

      print("Пользователь вошел в систему");
    } catch (e) {
      print("Ошибка входа");
    }
  }

  Future<void> closeConnection() async {
    // Закрываем соединение с базой данных при завершении
    await connection.close();
    print("Соединение закрыто");
  }
}

void main() async {
  final connectionTest = ConnectionTest();

  // Инициализируем соединение с базой данных
  await connectionTest._initializeDatabaseConnection();

  // Введите данные для регистрации пользователя
  stdout.writeln("Логин");
  final username = stdin.readLineSync();

  stdout.writeln("Пароль");
  final password = stdin.readLineSync();

  // Вызываем метод регистрации пользователя
  await connectionTest.register(username!, password!);

  // Закрываем соединение с базой данных
  await connectionTest.closeConnection();
}




