import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/providers/category_provider.dart';
import 'package:todo_list_app/screens/categories_screen.dart';
import 'package:todo_list_app/screens/completed_screen.dart';
import 'package:todo_list_app/screens/home_screen.dart';
import 'package:todo_list_app/screens/settings_screen.dart';
import 'package:todo_list_app/screens/todos_by_category.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoriesList = [];
  // CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    // getAllCategories();
  }

  getAllCategories() async {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    _categoriesList.clear();
    //var categories = categoryProvider.categoriesList;//await _categoryService.readCategories();
    categoryProvider.categoriesList.forEach((category) {
      setState(() {
        _categoriesList.add(InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new TodosByCategory(
                        category: category.name,
                      ))),
          child: ListTile(
            title: Text(
              category.name,
              style: TextStyle(color: Color(category.color)),
            ),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    // getAllCategories();
    return Container(
      child: Drawer(
        child: Column(
          children: <Widget>[
            /* UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://www.miraton.ua/upload/medialibrary/820/mini2.png"),
              ),
                accountName: Text("accountName"),
                accountEmail: Text("accountEmail"),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),),*/
            SizedBox(
              height: 50,
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("home").tr(),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.check_box_outlined),
              title: Text("completed").tr(),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CompletedScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("categories").tr(),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                  itemCount: categoryProvider.categoriesList.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) => InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new TodosByCategory(
                                      category: categoryProvider
                                          .categoriesList[index].name,
                                    ))),
                        child: ListTile(
                          title: Text(
                            categoryProvider.categoriesList[index].name,
                            style: TextStyle(
                                color: Color(categoryProvider
                                    .categoriesList[index].color)),
                          ),
                        ),
                      ))),
            ),
            Divider(),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  leading: Icon(Icons.view_list),
                  title: Text("settings").tr(),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsScreen())),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
