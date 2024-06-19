import 'package:flutter/material.dart';

class EmployeesScreen extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> employees;

  const EmployeesScreen({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Employee list"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: FutureBuilder(
              future: employees,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: snapshot.data!
                          .map<Widget>(
                            (emp) => Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "${emp['LAST_NAME']}, ${emp['FIRST_NAME']}",
                                ),
                                subtitle: Text(
                                  "Salary: ${emp['SALARY'].toStringAsFixed(2)}",
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(value: null),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
