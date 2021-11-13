import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/screens/todo_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class TodoListScreen1<T> extends StatefulWidget {
  List<Todo> _todoList;
  final Function() getTodos;
  TodoListScreen1(this._todoList, this.getTodos);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState<T> extends State<TodoListScreen1> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  ListModel<Todo> _list;
  final DateFormat _dateFormat = DateFormat("yy-MM-dd");

  @override
  void initState() {
    super.initState();
    getList();
  }

  Future<void> getList() async {
    widget._todoList = await widget.getTodos();
    _list = ListModel<Todo>(
      listKey: _listKey,
      initialItems: widget._todoList,
      removedItemBuilder: _buildRemovedItem,
    );
  }

// Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
    );
  }

  Widget _buildRemovedItem(
      Todo item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,

      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StickyGroupedListView<Todo, String>(
              elements: widget._todoList,
              groupBy: (element) => getSeparatorDate(element),
              groupComparator: (value1, value2) => value2.compareTo(value1),
              itemComparator: (item1, item2) =>
                  item1.todoDate.compareTo(item2.todoDate),
              order: StickyGroupedListOrder.DESC,
              groupSeparatorBuilder: (Todo element) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getSeparatorDate(element),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              itemBuilder: (c, element) {
                return Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Icon(Icons.account_circle),
                      title: Text(element.title),
                    ),
                  ),
                );
              },
            )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  TodoScreen(getTodos: widget.getTodos, todo: new Todo()))),
        ));
  }

  String getSeparatorDate(Todo value) {
    return _dateFormat
        .format(DateTime.fromMillisecondsSinceEpoch(value.todoDate));
  }
}

class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  SliverAnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatelessWidget {
  const CardItem({Key key, @required this.animation, @required this.item})
      : assert(animation != null),
        assert(item != null),
        super(key: key);

  final Animation<double> animation;
  final Todo item;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 80.0,
            child: Card(
              color: Colors.red,
              child: Center(
                child: Text('Item $item', style: textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
