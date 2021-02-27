import 'package:flutter/material.dart';
import 'package:todo_list_app/screens/categories_screen.dart';
import 'package:todo_list_app/screens/completed_screen.dart';
import 'package:todo_list_app/screens/home_screen.dart';
import 'package:todo_list_app/screens/todos_by_category.dart';
import 'package:todo_list_app/services/category_service.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoriesList = List<Widget>();
  CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoriesList.clear();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categoriesList.add(InkWell(
          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => new TodosByCategory(category: category["name"],))),
          child: ListTile(
            title: Text(category["name"],style: TextStyle(color: Color(category["color"])),),
          ),
        ));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
           /* UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://www.miraton.ua/upload/medialibrary/820/mini2.png"),
              ),
                accountName: Text("accountName"),
                accountEmail: Text("accountEmail"),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),),*/
            ListTile(
              leading: Icon(Icons.home),
                title: Text("home").tr(),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.check_box_outlined),
              title: Text("completed").tr(),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CompletedScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("categories").tr(),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesScreen())),
            ),
            Divider(),
            Column(
              children: _categoriesList,
            )
          ],
        ),
      ),
    );
  }
}
