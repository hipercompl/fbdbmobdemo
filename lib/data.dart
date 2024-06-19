import "package:fbdb/fbdb.dart";

class LoginParams {
  String host = "";
  int port = 3050;
  String database = "employee";
  String user = "SYSDBA";
  String password = "masterkey";

  static final data = LoginParams();
}

class Database {
  static FbDb? db;

  static Future<void> testLogin({bool withError = false, int delay = 1}) async {
    await Future.delayed(Duration(seconds: delay));
    if (withError) {
      throw Exception(
        "Your user name and password are not defined. "
        "Please provide valid Firebird user credentials.",
      );
    }
  }

  static Future<void> login() async {
    if (db != null) {
      await db?.detach();
    }
    db = await FbDb.attach(
      host: LoginParams.data.host,
      port: LoginParams.data.port,
      database: LoginParams.data.database,
      user: LoginParams.data.user,
      password: LoginParams.data.password,
    );
  }

  static Future<List<Map<String, dynamic>>> testLoadEmployees(
      {bool withError = false, int delay = 1}) async {
    try {
      await Future.delayed(Duration(seconds: delay));
      if (withError) {
        throw Exception("Error reading data from the database");
      } else {
        return [
          {"FIRST_NAME": "JOHN1", "LAST_NAME": "WICK1", "SALARY": 1200.55},
          {"FIRST_NAME": "JOHN2", "LAST_NAME": "WICK2", "SALARY": 455.50},
          {"FIRST_NAME": "JOHN3", "LAST_NAME": "WICK3", "SALARY": 788.0},
          {"FIRST_NAME": "JOHN4", "LAST_NAME": "WICK4", "SALARY": 45777.21},
        ];
      }
    } finally {
      await db?.detach();
    }
  }

  static Future<List<Map<String, dynamic>>> loadEmployees() async {
    if (db == null) {
      throw Exception("Not attached to the employees database");
    }
    FbQuery? q = db?.query();
    if (q == null) {
      throw Exception("Query creation failed");
    }
    try {
      await q.openCursor(
        sql: "select FIRST_NAME, LAST_NAME, SALARY "
            "from EMPLOYEE "
            "order by LAST_NAME, FIRST_NAME",
      );
      final emps = await q.rows().toList();
      return emps;
    } finally {
      await q.close();
    }
  }
}
