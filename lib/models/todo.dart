class Todo {
  int id;
  String title;
  String description;
  int todoDate;
  String category;
  int isFinished;
  String repeat;
  todoMap(){
    var mapping = Map<String, dynamic>();
    mapping["id"] = id;
    mapping["title"] = title;
    mapping["description"] = description;
    mapping["todoDate"] = todoDate;
    mapping["category"] = category;
    mapping["isFinished"] = isFinished;
    mapping["repeat"] = repeat;

    return mapping;
  }
}