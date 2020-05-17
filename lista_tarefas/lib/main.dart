import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    title: "Lista de Tarefas",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _todoController = TextEditingController();
  List _ToDoList = [];
  Map<String, dynamic> _remove;
  int _removePosition;

  @override
  void initState(){
    super.initState();

    _readData().then((data) {
      setState(() {
        _ToDoList = json.decode(data);  
      });
      
    });
  }

  Widget buildItem (BuildContext context, int index) {
                return Dismissible(
                  key: Key(DateTime.now().millisecondsSinceEpoch.toString()),

                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment(-0.9,0.0),
                      child: Icon(Icons.delete, color: Colors.white,),

                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  child: CheckboxListTile(
                      title: Text(_ToDoList[index]["title"],),
                      value: _ToDoList[index]["ok"],
                      secondary: CircleAvatar(
                        child: Icon(_ToDoList[index]["ok"] ? Icons.check : Icons.error),),
                      onChanged: (c){
                        setState(() {
                          _ToDoList[index]["ok"] = c;
                          _saveData();
                        });
                      },  
                    ),
                    onDismissed: (direction){
                      
                      setState(() {
                        _remove = Map.from(_ToDoList[index]);
                      _removePosition = index;
                      _ToDoList.removeAt(index);

                      _saveData();

                      final snack = SnackBar(
                        content: Text("tarefa ${_remove["title"]} removida"),
                        action: SnackBarAction(
                          label: "Desfazer",
                          onPressed: (){
                              setState(() {
                                _ToDoList.insert(_removePosition, _remove);
                                _saveData();
                            });
                          },
                        ),
                        duration: Duration(seconds: 2),
                      );  

                      Scaffold.of(context).showSnackBar(snack);
                      });
                      
                    },
                );
              }

  void _addToDo(){
    setState(() {
      Map<String, dynamic> novaTarefa = Map(); 
        novaTarefa["title"] = _todoController.text;
        _todoController.text ="";
        novaTarefa["ok"] = false;
        _ToDoList.add(novaTarefa);
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/arquivo.json");
  } 

  Future<File> _saveData() async {
    String arquivo = json.encode(_ToDoList);
    final file = await _getFile();
    return file.writeAsString(arquivo);
    _saveData();
  }

  Future<String> _readData() async{
    try
    {
      final file = await _getFile();
      return file.readAsString();
    }
    catch (e)
    {
      return null;
    }
  }

  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));

    setState(() {

      _ToDoList.sort((a,b){
        if(a["ok"] && !b["ok"]) return 1;
        else if(!a["ok"] && b["ok"]) return -1;
        else return 0;
      });  

      _saveData();
    });

    return null;
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0,),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                  decoration : InputDecoration(
                  labelText: "Nova Tarefa",
                  labelStyle: TextStyle(color: Colors.blueAccent)
                  ),
                  )  
                ),

                RaisedButton(
                  color: Colors.greenAccent,
                  child: Text("Adicionar"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(onRefresh: _refresh,
            child: ListView.builder(
              padding: EdgeInsets.only(top:10.0),
              itemCount: _ToDoList.length,
              itemBuilder: buildItem),
            ),
          )
        ],
      ),
    );
  }
}

