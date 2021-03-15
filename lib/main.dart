import 'package:flutter/material.dart';
import 'todo.dart';
import 'databaseHelper.dart';

//https://www.javacodegeeks.com/2020/06/using-sqlite-in-flutter-tutorial.html
// flutter/sqlite tutorial

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Listify'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = new TextEditingController();
  List<Todo> taskList = new List();

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          taskList.add(Todo(id: element['id'], title: element["title"]));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Enter a task"),
                    controller: textController,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: null,
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: taskList.isEmpty
                    ? Container()
                    : ListView.builder(itemBuilder: (ctx, index) {
                  if (index == taskList.length) return null;
                  return ListTile(
                    title: Text(taskList[index].title),
                    leading: Text(taskList[index].id.toString()),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

}