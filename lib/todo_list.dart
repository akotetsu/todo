import 'package:flutter/material.dart';
import 'package:practice/todo_add.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // todoListを文字列とチェック状態を含むMapに変更
  List<Map<String, dynamic>> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('リスト一覧'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            final todo = todoList[index];
            return Card(
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    // チェック状態をトグルする
                    setState(() {
                      todo['isChecked'] = !todo['isChecked'];
                    });
                  },
                  child: Icon(
                    // チェック状態に応じてアイコンを切り替え
                    todo['isChecked']
                        ? Icons.check_circle_outline
                        : Icons.check_box_outline_blank_outlined,
                    color: todo['isChecked'] ? Colors.red : null, // 赤色マーク
                  ),
                ),
                title: Text(
                  todo['text'],
                  style: TextStyle(
                    decoration: todo['isChecked']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none, // チェック時に取り消し線
                  ),
                ),
                // 削除アイコンを追加
                trailing: IconButton(
                  icon: const Icon(Icons.restore_from_trash),
                  color: Colors.red, // ゴミ箱アイコンの色を赤に設定
                  onPressed: () {
                    // 削除の確認ダイアログを表示
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('削除確認'),
                          content: const Text('このTODOを削除しますか？'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // ダイアログを閉じる
                              },
                              child: const Text('キャンセル'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  todoList.removeAt(index); // TODOをリストから削除
                                });
                                Navigator.of(context).pop(); // ダイアログを閉じる
                              },
                              child: const Text('削除'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"で新規画面に遷移
          final newListText = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoAddPage()),
          );
          if (newListText != null) {
            // キャンセルした場合は newListText が null となるので注意
            setState(() {
              todoList.add({'text': newListText, 'isChecked': false});
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
