import 'package:flutter/material.dart';

import "data.dart";
import "employees_screen.dart";

class LoginScreen extends StatelessWidget {
  final String title;
  const LoginScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: const LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Host name or IP",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Firebird host is required";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() => LoginParams.data.host = value ?? "");
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Port number",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: LoginParams.data.port.toString(),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      try {
                        final port = int.parse(value);
                        if (port < 1 || port > 65535) {
                          throw Exception("Port out of range");
                        }
                      } catch (_) {
                        return "Invalid port number";
                      }
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() =>
                        LoginParams.data.port = int.parse(value ?? "3050"));
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Database path or alias",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: LoginParams.data.database,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Database location required";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() => LoginParams.data.database = value ?? "");
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "User name",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: LoginParams.data.user,
                  onSaved: (value) {
                    setState(() => LoginParams.data.user = value ?? "");
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  initialValue: LoginParams.data.password,
                  onSaved: (value) {
                    setState(() => LoginParams.data.password = value ?? "");
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                FilledButton(
                  onPressed: () async {
                    // guard against multiple login attempts
                    if (inProgress) {
                      return;
                    }
                    inProgress = true;
                    try {
                      final form = _formKey.currentState;
                      if (form != null) {
                        if (form.validate()) {
                          form.save();
                          _showLoginProgress(context);
                          try {
                            // await Database.testLogin(withError: false);
                            await Database.login();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Login error"),
                                  content: Text(e.toString()),
                                ),
                              );
                              return;
                            }
                          }
                          // final employees =
                          //     Database.testLoadEmployees(withError: false);
                          // We don't await loading the employees, because
                          // the employees screen uses a FutureBuilder.
                          final employees = Database.loadEmployees();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    EmployeesScreen(employees: employees),
                              ),
                            );
                          }
                        }
                      }
                    } finally {
                      inProgress = false;
                    }
                  },
                  child: const Text("CONNECT"),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showLoginProgress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(
              value: null,
            ),
            SizedBox(
              width: 16.0,
            ),
            Text("Attaching to the database"),
          ],
        ),
      ),
    );
  }
}
